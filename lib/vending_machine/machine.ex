defmodule VendingMachine.Machine do
  defstruct coin_return: [],
            bank: [],
            inventory: [],
            staging: [],
            display: "INSERT COIN",
            bin: [],
            grid: %{cola: false, chips: false, candy: false},
            ledger: %{cola: 1.0, chips: 0.50, candy: 0.65}
end
