defmodule VendingMachine.Server do
  use GenServer
  alias VendingMachine.Impl

  def init(initial_vending_machine) do
    {:ok, initial_vending_machine}
  end

  def handle_cast({:insert_coin, coin}, current_vending_machine) do
    {:noreply, Impl.insert_coin(current_vending_machine, coin)}
  end

  def handle_cast({:select_product, product}, current_vending_machine) do
    {:noreply, Impl.select_product(current_vending_machine, product)}
  end
end
