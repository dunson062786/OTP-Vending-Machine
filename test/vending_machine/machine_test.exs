defmodule VendingMachine.MachineTest do
  use ExUnit.Case
  doctest VendingMachine.Machine

  describe "VendingMachine.Machine.equal?/2" do
    test "considers two default vending machines equal" do
      vending_machine_one = %VendingMachine.Machine{}
      vending_machine_two = %VendingMachine.Machine{}
      assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == true
    end

    test "vending machines with different display are not equal" do
      vending_machine_one = %VendingMachine.Machine{
        display: nil
      }

      vending_machine_two = %VendingMachine.Machine{
        display: "PRICE $1.00"
      }

      assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == false
    end

    test "vending machines with different coins in coin_return are not equal" do
      vending_machine_one = %VendingMachine.Machine{
        coin_return: [VendingMachine.Coin.createQuarter(), VendingMachine.Coin.createDime()]
      }

      vending_machine_two = %VendingMachine.Machine{
        coin_return: [VendingMachine.Coin.createQuarter(), VendingMachine.Coin.createQuarter()]
      }

      assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == false
    end

    test "vending machines with same coins in coin_return, but different order are equal" do
      vending_machine_one = %VendingMachine.Machine{
        coin_return: [VendingMachine.Coin.createQuarter(), VendingMachine.Coin.createDime()]
      }

      vending_machine_two = %VendingMachine.Machine{
        coin_return: [VendingMachine.Coin.createDime(), VendingMachine.Coin.createQuarter()]
      }

      assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == true
    end

    test "vending machines with different banks are not equal" do
      vending_machine_one = %VendingMachine.Machine{
        bank: %VendingMachine.CoinStorage{
          wallet: [VendingMachine.Coin.createQuarter()],
          tally: %{quarter: 1, dime: 0, nickel: 0},
          total: 25
        }
      }

      vending_machine_two = %VendingMachine.Machine{
        bank: %VendingMachine.CoinStorage{
          wallet: [VendingMachine.Coin.createDime()],
          tally: %{quarter: 0, dime: 1, nickel: 0},
          total: 10
        }
      }

      assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == false
    end

    test "vending machines with same banks different order are equal" do
      vending_machine_one = %VendingMachine.Machine{
        bank: %VendingMachine.CoinStorage{
          wallet: [VendingMachine.Coin.createQuarter(), VendingMachine.Coin.createDime()],
          tally: %{quarter: 1, dime: 1, nickel: 0},
          total: 35
        }
      }

      vending_machine_two = %VendingMachine.Machine{
        bank: %VendingMachine.CoinStorage{
          wallet: [VendingMachine.Coin.createDime(), VendingMachine.Coin.createQuarter()],
          tally: %{quarter: 1, dime: 1, nickel: 0},
          total: 35
        }
      }

      assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == true
    end

    test "vending machines with different inventory are not equal" do
      vending_machine_one = %VendingMachine.Machine{
        inventory: [
          VendingMachine.Product.createCola()
        ]
      }
      vending_machine_two = %VendingMachine.Machine{
        inventory: [VendingMachine.Product.createCandy()]
      }

      assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == false
    end

    test "vending machines with same inventory different order are equal" do
      vending_machine_one = %VendingMachine.Machine{
        inventory: [
          VendingMachine.Product.createCola(),
          VendingMachine.Product.createCandy()
        ]
      }
      vending_machine_two = %VendingMachine.Machine{
        inventory: [VendingMachine.Product.createCandy(), VendingMachine.Product.createCola()]
      }

      assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == true
    end
  end

  test "vending machines with different staging are not equal" do
    vending_machine_one = %VendingMachine.Machine{
      staging: %VendingMachine.CoinStorage{
        wallet: [VendingMachine.Coin.createQuarter()],
        tally: %{quarter: 1, dime: 0, nickel: 0},
        total: 25
      }
    }

    vending_machine_two = %VendingMachine.Machine{
      staging: %VendingMachine.CoinStorage{
        wallet: [VendingMachine.Coin.createDime()],
        tally: %{quarter: 0, dime: 1, nickel: 0},
        total: 10
      }
    }

    assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == false
  end

  test "vending machines with same staging different order are equal" do
    vending_machine_one = %VendingMachine.Machine{
      staging: %VendingMachine.CoinStorage{
        wallet: [VendingMachine.Coin.createQuarter(), VendingMachine.Coin.createDime()],
        tally: %{quarter: 1, dime: 1, nickel: 0},
        total: 35
      }
    }

    vending_machine_two = %VendingMachine.Machine{
      staging: %VendingMachine.CoinStorage{
        wallet: [VendingMachine.Coin.createDime(), VendingMachine.Coin.createQuarter()],
        tally: %{quarter: 1, dime: 1, nickel: 0},
        total: 35
      }
    }

    assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == true
  end

  test "vending machines with different bin are not equal" do
    vending_machine_one = %VendingMachine.Machine{
      bin: [
        VendingMachine.Product.createCola()
      ]
    }
    vending_machine_two = %VendingMachine.Machine{
      bin: [VendingMachine.Product.createCandy()]
    }

    assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == false
  end

  test "vending machines with same bin different order are equal" do
    vending_machine_one = %VendingMachine.Machine{
      bin: [
        VendingMachine.Product.createCola(),
        VendingMachine.Product.createCandy()
      ]
    }
    vending_machine_two = %VendingMachine.Machine{
      bin: [VendingMachine.Product.createCandy(), VendingMachine.Product.createCola()]
    }

    assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == true
  end

  test "vending machines with different grid are not equal" do
    vending_machine_one = %VendingMachine.Machine{
      grid: %{cola: false, chips: false, candy: false}
    }
    vending_machine_two = %VendingMachine.Machine{
      grid: %{cola: true, chips: false, candy: false}
    }

    assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == false
  end

  test "vending machines with same grid are equal" do
    vending_machine_one = %VendingMachine.Machine{
      grid: %{cola: false, chips: false, candy: false}
    }
    vending_machine_two = %VendingMachine.Machine{
      grid: %{cola: false, chips: false, candy: false}
    }

    assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == true
  end

  test "vending machines with different ledger are not equal" do
    vending_machine_one = %VendingMachine.Machine{
      ledger: %{cola: 100, chips: 50, candy: 65}
    }
    vending_machine_two = %VendingMachine.Machine{
      ledger: %{cola: 200, chips: 100, candy: 130}
    }

    assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == false
  end

  test "vending machines with same ledger are equal" do
    vending_machine_one = %VendingMachine.Machine{
      ledger: %{cola: 200, chips: 100, candy: 130}
    }
    vending_machine_two = %VendingMachine.Machine{
      ledger: %{cola: 200, chips: 100, candy: 130}
    }

    assert VendingMachine.Machine.equal?(vending_machine_one, vending_machine_two) == true
  end
end
