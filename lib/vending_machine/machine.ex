defmodule VendingMachine.Machine do
  defstruct coin_return: [],
            bank: %VendingMachine.CoinStorage{
              wallet: [
                VendingMachine.Coin.createDime(),
                VendingMachine.Coin.createNickel(),
                VendingMachine.Coin.createNickel()
              ],
              tally: %{quarter: 0, dime: 1, nickel: 2},
              total: 20
            },
            inventory: [],
            staging: %VendingMachine.CoinStorage{},
            display: nil,
            bin: [],
            grid: %{cola: false, chips: false, candy: false},
            ledger: %{cola: 100, chips: 50, candy: 65}

  def equal?(machine_one, machine_two) do
    machine_one.display == machine_two.display &&
      Enum.sort(machine_one.coin_return) == Enum.sort(machine_two.coin_return) &&
      VendingMachine.CoinStorage.equal?(machine_one.bank, machine_two.bank) &&
      Enum.sort(machine_one.inventory) == Enum.sort(machine_two.inventory) &&
      VendingMachine.CoinStorage.equal?(machine_one.staging, machine_two.staging) &&
      Enum.sort(machine_one.bin) == Enum.sort(machine_two.bin) &&
      machine_one.grid == machine_two.grid &&
      machine_one.ledger == machine_two.ledger
  end
end
