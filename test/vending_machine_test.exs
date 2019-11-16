defmodule VendingMachineTest do
  use ExUnit.Case, async: true
  doctest VendingMachine

  setup do
    vending_machine = start_supervised!(VendingMachine.Server)
    %{vending_machine: vending_machine}
  end

  describe "VendingMachine.insert_coin/2" do
    test "insert nickel adds nickel to staging", %{
      vending_machine: vm
    } do
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createNickel())

      assert equal?(VendingMachine.get_vending_machine(vm).staging.wallet, [
               VendingMachine.Coin.createNickel()
             ])
    end

    test "insert penny does not add penny to staging", %{
      vending_machine: vm
    } do
      VendingMachine.insert_coin(vm, %VendingMachine.Coin{weight: 2.5, name: :penny})

      assert equal?(VendingMachine.get_vending_machine(vm).staging.wallet, [])
    end
  end

  describe "VendingMachine.get_display/1" do
    test "displays INSERT COIN when vending machine can make change", %{
      vending_machine: vm
    } do
      assert VendingMachine.get_display(vm) == "INSERT COIN"
    end

    test "displays EXACT CHANGE ONLY when vending machine can not make change", %{
      vending_machine: vm
    } do
      VendingMachine.set_vending_machine(vm, %VendingMachine.Machine{
        bank: %VendingMachine.CoinStorage{}
      })

      assert VendingMachine.get_display(vm) == "EXACT CHANGE ONLY"
    end

    test "If user inserts coin and checks display then $0.25 is displayed", %{
      vending_machine: vm
    } do
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      assert VendingMachine.get_display(vm) == "$0.25"
    end
  end

  describe "VendingMachine.select_product/2" do
    test "If user selects product and not enough money has been insert then Vending Machine returns no products and no change",
         %{
           vending_machine: vm
         } do
      {products, change} = VendingMachine.select_product(vm, :cola)
      assert products == []
      assert change == []
    end

    test "If user select cola and $1.00 has been inserted then Vending Machine will return a cola and no change",
         %{
           vending_machine: vm
         } do
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      {products, change} = VendingMachine.select_product(vm, :cola)
      assert products == [VendingMachine.Product.createCola()]
      assert change == []
    end

    test "If user selects cola and $1.50 has been inserted then Vending Machine will return a cola and $0.50 in change",
         %{
           vending_machine: vm
         } do
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      {products, change} = VendingMachine.select_product(vm, :cola)
      assert products == [VendingMachine.Product.createCola()]
      assert change == [VendingMachine.Coin.createQuarter(), VendingMachine.Coin.createQuarter()]
    end

    test "If Vending Machine can not make change and $0.75 has been inserted and candy has been selected then Vending Machine will return $0.75 in change",
         %{
           vending_machine: vm
         } do
      empty_coin_storage = %VendingMachine.CoinStorage{}

      VendingMachine.set_vending_machine(vm, %VendingMachine.Machine{
        VendingMachine.get_vending_machine(vm)
        | bank: empty_coin_storage
      })

      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      {products, change} = VendingMachine.select_product(vm, :candy)
      assert equal?(products, [])

      assert equal?(change, [
               VendingMachine.Coin.createQuarter(),
               VendingMachine.Coin.createQuarter(),
               VendingMachine.Coin.createQuarter()
             ])
    end
  end

  describe "VendingMachine.get_vending_machine/1" do
    test "returns default vending machine if nothing has happened", %{
      vending_machine: vm
    } do
      assert VendingMachine.Machine.equal?(
               VendingMachine.get_vending_machine(vm),
               %VendingMachine.Machine{
                 inventory: [
                   VendingMachine.Product.createCola(),
                   VendingMachine.Product.createChips(),
                   VendingMachine.Product.createCandy()
                 ]
               }
             ) == true
    end

    test "VendingMachine.get_vending_machine/1 returns current vending machine", %{
      vending_machine: vm
    } do
      machine = %VendingMachine.Machine{
        bank: %VendingMachine.CoinStorage{
          wallet: [
            VendingMachine.Coin.createQuarter(),
            VendingMachine.Coin.createQuarter(),
            VendingMachine.Coin.createNickel()
          ],
          tally: %{quarter: 2, dime: 0, nickel: 1},
          total: 55
        }
      }

      VendingMachine.set_vending_machine(vm, machine)

      assert VendingMachine.Machine.equal?(
               VendingMachine.get_vending_machine(vm),
               %VendingMachine.Machine{}
             ) == false

      assert VendingMachine.Machine.equal?(VendingMachine.get_vending_machine(vm), machine) ==
               true
    end
  end

  describe "VendingMachine.set_vending_machine/1" do
    test "changes the current vending machine", %{
      vending_machine: vm
    } do
      machine = %VendingMachine.Machine{
        bank: %VendingMachine.CoinStorage{
          wallet: [
            VendingMachine.Coin.createQuarter(),
            VendingMachine.Coin.createQuarter(),
            VendingMachine.Coin.createNickel()
          ],
          tally: %{quarter: 2, dime: 0, nickel: 1},
          total: 55
        }
      }

      VendingMachine.set_vending_machine(vm, machine)

      assert VendingMachine.Machine.equal?(
               VendingMachine.get_vending_machine(vm),
               %VendingMachine.Machine{}
             ) == false

      assert VendingMachine.Machine.equal?(VendingMachine.get_vending_machine(vm), machine) ==
               true
    end
  end

  describe "VendingMachine.return_coins/1" do
    test "returns an empty array if no coins have been inserted", %{vending_machine: vm} do
      assert equal?(VendingMachine.return_coins(vm), [])
    end

    test "returns a quarter if a quarter has been inserted", %{vending_machine: vm} do
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      assert equal?(VendingMachine.return_coins(vm), [VendingMachine.Coin.createQuarter()])
    end

    test "returns all coins inserted", %{vending_machine: vm} do
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createQuarter())
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createDime())
      VendingMachine.insert_coin(vm, VendingMachine.Coin.createNickel())

      assert equal?(VendingMachine.return_coins(vm), [
               VendingMachine.Coin.createDime(),
               VendingMachine.Coin.createNickel(),
               VendingMachine.Coin.createQuarter()
             ])
    end
  end

  defp equal?(list1, list2) do
    Enum.sort(list1) == Enum.sort(list2)
  end
end
