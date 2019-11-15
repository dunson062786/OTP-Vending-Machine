defmodule VendingMachineTest do
  use ExUnit.Case, async: true
  doctest VendingMachine

  setup do
    vending_machine = start_supervised!(VendingMachine.Server)
    %{vending_machine: vending_machine}
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
    test "If user selects product and not enough money has been insert then Vending Machine returns no products and no change", %{
      vending_machine: vm
    } do
      {products, change} = VendingMachine.select_product(vm, :cola)
      assert products == []
      assert change == []
    end

    test "If user select cola and $1.00 has been inserted then Vending Machine will return a cola and no change", %{
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

    test "If user selects cola and $1.50 has been inserted then Vending Machine will return a cola and $0.50 in change", %{
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
      assert VendingMachine.Machine.equal?(VendingMachine.get_vending_machine(vm), %VendingMachine.Machine{}) == false
      assert VendingMachine.Machine.equal?(VendingMachine.get_vending_machine(vm), machine) == true
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
      assert VendingMachine.Machine.equal?(VendingMachine.get_vending_machine(vm), %VendingMachine.Machine{}) == false
      assert VendingMachine.Machine.equal?(VendingMachine.get_vending_machine(vm), machine) == true
    end
  end
end
