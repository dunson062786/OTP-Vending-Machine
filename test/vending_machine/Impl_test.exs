defmodule VendingMachine.ImplTest do
  use ExUnit.Case
  doctest VendingMachine.Impl

  @invalid %VendingMachine.Coin{weight: 2.5}
  @nickel %VendingMachine.Coin{weight: 5.0}
  @dime %VendingMachine.Coin{weight: 2.268}
  @quarter %VendingMachine.Coin{weight: 5.670}

  describe "VendingMachine.Impl.insert_coin/2" do
    test "Adding valid coin to vending machine updates staging" do
      vm = %VendingMachine.Machine{}
      vm = VendingMachine.Impl.insert_coin(vm, @quarter)
      assert vm.staging == [@quarter]
    end

    test "Adding invalid coin updates coin_return" do
      vm = %VendingMachine.Machine{}
      vm = VendingMachine.Impl.insert_coin(vm, @invalid)
      assert vm.coin_return == [@invalid]
    end

    test "If staging is empty and you insert an invalid coin vending machine still displays 'INSERT COIN'" do
      vm = %VendingMachine.Machine{}
      vm = VendingMachine.Impl.insert_coin(vm, @invalid)
      assert vm.display == "INSERT COIN"
    end

    test "If staging is empty and you insert a nickel vending machine displays 0.05" do
      vm = %VendingMachine.Machine{}
      vm = VendingMachine.Impl.insert_coin(vm, @nickel)
      assert vm.display == 0.05
    end

    test "If staging is empty and you insert a nickel vending machine displays 0.10" do
      vm = %VendingMachine.Machine{}
      vm = VendingMachine.Impl.insert_coin(vm, @dime)
      assert vm.display == 0.10
    end

    test "If staging is empty and you insert a quarter vending machine displays 0.25" do
      vm = %VendingMachine.Machine{}
      vm = VendingMachine.Impl.insert_coin(vm, @quarter)
      assert vm.display == 0.25
    end
  end

  describe "VendingMachine.Impl.select_product/2 grid functionality" do
    setup do
      %{
        vending_machine: %VendingMachine.Machine{
          inventory: [
            %Product{name: :cola},
            %Product{name: :chips},
            %Product{name: :candy}
          ]
        }
      }
    end

    test "selects cola if not sold out and selected for the first time", %{vending_machine: vm} do
      vm = VendingMachine.Impl.select_product(vm, :cola)
      assert vm.grid.cola == true
    end

    test "selects chips if not sold out and selected for the first time", %{vending_machine: vm} do
      vm = VendingMachine.Impl.select_product(vm, :chips)
      assert vm.grid.chips == true
    end

    test "selects candy if not sold out and selected for the first time", %{vending_machine: vm} do
      vm = VendingMachine.Impl.select_product(vm, :candy)
      assert vm.grid.candy == true
    end

    test "deselects cola if chips is selected", %{vending_machine: vm} do
      vm = VendingMachine.Impl.select_product(vm, :cola)
      vm = VendingMachine.Impl.select_product(vm, :chips)
      assert vm.grid.cola == false
    end

    test "deselects chips if cola is selected", %{vending_machine: vm} do
      vm = VendingMachine.Impl.select_product(vm, :chips)
      vm = VendingMachine.Impl.select_product(vm, :cola)
      assert vm.grid.chips == false
    end

    test "deselects candy if cola is selected", %{vending_machine: vm} do
      vm = VendingMachine.Impl.select_product(vm, :candy)
      vm = VendingMachine.Impl.select_product(vm, :cola)
      assert vm.grid.candy == false
    end

    test "deselects cola if selected again", %{vending_machine: vm} do
      vm =
        VendingMachine.Impl.select_product(vm, :cola)
        |> VendingMachine.Impl.select_product(:cola)

      assert vm.grid.cola == false
    end

    test "deselects chips if selected again", %{vending_machine: vm} do
      vm =
        VendingMachine.Impl.select_product(vm, :chips)
        |> VendingMachine.Impl.select_product(:chips)

      assert vm.grid.chips == false
    end

    test "deselects candy if selected again", %{vending_machine: vm} do
      vm =
        VendingMachine.Impl.select_product(vm, :candy)
        |> VendingMachine.Impl.select_product(:candy)

      assert vm.grid.candy == false
    end
  end

  describe "VendingMachine.Impl.select_product/2 display functionality of full Vending Machine" do
    setup do
      %{
        vending_machine: %VendingMachine.Machine{
          inventory: [
            %Product{name: :cola},
            %Product{name: :chips},
            %Product{name: :candy}
          ]
        }
      }
    end

    test "if cola selected and staging is not enough then price of cola is displayed", %{
      vending_machine: vm
    } do
      vm = VendingMachine.Impl.select_product(vm, :cola)
      assert vm.display == "PRICE $1.00"
    end

    test "if chips selected and staging is not enough then price of chips is displayed", %{
      vending_machine: vm
    } do
      vm = VendingMachine.Impl.select_product(vm, :chips)
      assert vm.display == "PRICE $0.50"
    end

    test "if candy selected and staging is not enough then price of candy is displayed", %{
      vending_machine: vm
    } do
      vm = VendingMachine.Impl.select_product(vm, :candy)
      assert vm.display == "PRICE $0.65"
    end

    test "if cola selected and staging has enough money then THANK YOU is displayed", %{
      vending_machine: vm
    } do
      vm =
        VendingMachine.Impl.insert_coin(vm, @quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)

      vm = VendingMachine.Impl.select_product(vm, :cola)

      assert vm.display == "THANK YOU"
    end
  end

  describe "VendingMachine.Impl.select_product/2 display functionality of non-full Vending Machine" do
    setup do
      %{
        vending_machine: %VendingMachine.Machine{}
      }
    end

    test "if cola selected and sold out then vending machine displays SOLD OUT", %{
      vending_machine: vm
    } do
      vm = VendingMachine.Impl.select_product(vm, :cola)

      assert vm.display == "SOLD OUT"
    end

    test "if chips selected and sold out then vending machine displays SOLD OUT", %{
      vending_machine: vm
    } do
      vm = VendingMachine.Impl.select_product(vm, :chips)

      assert vm.display == "SOLD OUT"
    end

    test "if candy selected and sold out then vending machine displays SOLD OUT", %{
      vending_machine: vm
    } do
      vm = VendingMachine.Impl.select_product(vm, :candy)

      assert vm.display == "SOLD OUT"
    end
  end

  describe "VendingMachine.Impl.select_product/2 vending functionality of full Vending Machine" do
    setup do
      %{
        vending_machine: %VendingMachine.Machine{
          inventory: [
            %Product{name: :cola},
            %Product{name: :chips},
            %Product{name: :candy}
          ]
        }
      }
    end

    test "if cola selected and staging has enough money then product is dispensed", %{
      vending_machine: vm
    } do
      vm =
        VendingMachine.Impl.insert_coin(vm, @quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)

      vm = VendingMachine.Impl.select_product(vm, :cola)

      assert vm.bin == [%Product{name: :cola}]
    end

    test "if cola selected and not sold out and staging has enough money then cola inventory decreases by one",
         %{vending_machine: vm} do
      vm =
        VendingMachine.Impl.insert_coin(vm, @quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)

      vm = VendingMachine.Impl.select_product(vm, :cola)

      assert vm.inventory == [%Product{name: :chips}, %Product{name: :candy}]
    end

    test "if chips selected and staging has enough money then product is dispensed", %{
      vending_machine: vm
    } do
      vm =
        VendingMachine.Impl.insert_coin(vm, @quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)

      vm = VendingMachine.Impl.select_product(vm, :chips)

      assert vm.bin == [%Product{name: :chips}]
    end

    test "if chips selected and not sold out and staging has enough money then chips inventory decreases by one",
         %{vending_machine: vm} do
      vm =
        VendingMachine.Impl.insert_coin(vm, @quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)

      vm = VendingMachine.Impl.select_product(vm, :chips)

      assert vm.inventory == [%Product{name: :cola}, %Product{name: :candy}]
    end

    test "if candy selected and staging has enough money then product is dispensed", %{
      vending_machine: vm
    } do
      vm =
        VendingMachine.Impl.insert_coin(vm, @quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)

      vm = VendingMachine.Impl.select_product(vm, :candy)

      assert vm.bin == [%Product{name: :candy}]
    end

    test "if candy selected and not sold out and staging has enough money then candy inventory decreases by one",
         %{vending_machine: vm} do
      vm =
        VendingMachine.Impl.insert_coin(vm, @quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)

      vm = VendingMachine.Impl.select_product(vm, :candy)

      assert vm.inventory == [%Product{name: :cola}, %Product{name: :chips}]
    end
  end

  describe "VendingMachine.Impl.remove_product_from_bin/2" do
    setup do
      %{
        vending_machine: %VendingMachine.Machine{
          bin: [
            %Product{name: :cola}
          ]
        }
      }
    end

    test "After removing the product bin is empty and display says insert coin", %{
      vending_machine: vm
    } do
      vm = VendingMachine.Impl.remove_product_from_bin(vm, %Product{name: :cola})
      assert vm.bin == []
      assert vm.display == "INSERT COIN"
    end
  end

  describe "VendingMachine.Impl.select_product/2 returns correct change" do
    setup do
      %{
        vending_machine: %VendingMachine.Machine{
          inventory: [
            %Product{name: :cola},
            %Product{name: :chips},
            %Product{name: :candy}
          ],
          bank: [
            @quarter,
            @quarter,
            @quarter,
            @quarter,
            @dime,
            @dime,
            @dime,
            @dime,
            @nickel,
            @nickel,
            @nickel,
            @nickel
          ]
        }
      }
    end

    test "If 75c is deposited and candy is selected then 10c is returned", %{vending_machine: vm} do
      vm =
        VendingMachine.Impl.insert_coin(vm, @quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)
        |> VendingMachine.Impl.insert_coin(@quarter)

      vm = VendingMachine.Impl.select_product(vm, :candy)

      assert vm.coin_return == [@dime]
    end
  end
end
