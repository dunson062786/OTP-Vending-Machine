defmodule VendingMachine.Machine do
  defstruct coin_return: [],
            bank: %CoinStorage{
              wallet: [
                VendingMachine.Coin.createDime(),
                VendingMachine.Coin.createNickel(),
                VendingMachine.Coin.createNickel()
              ],
              tally: %{quarter: 0, dime: 1, nickel: 2},
              total: 20
            },
            inventory: [],
            staging: %CoinStorage{},
            display: nil,
            bin: [],
            grid: %{cola: false, chips: false, candy: false},
            ledger: %{cola: 100, chips: 50, candy: 65}
end
