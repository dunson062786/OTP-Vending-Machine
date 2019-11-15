defmodule VendingMachine.CoinTest do
  use ExUnit.Case
  doctest VendingMachine.Coin

  test "VendingMachine.Coin.createQuarter/1" do
    assert VendingMachine.Coin.createQuarter() == %VendingMachine.Coin{
             weight: 5.670,
             name: :quarter
           }
  end

  test "VendingMachine.Coin.createDime/1" do
    assert VendingMachine.Coin.createDime() == %VendingMachine.Coin{weight: 2.268, name: :dime}
  end

  test "VendingMachine.Coin.createNickel/1" do
    assert VendingMachine.Coin.createNickel() == %VendingMachine.Coin{weight: 5.0, name: :nickel}
  end
end
