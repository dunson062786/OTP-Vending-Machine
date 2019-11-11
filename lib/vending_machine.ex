defmodule VendingMachine do
  @server VendingMachine.Server

  def start_link(current_vending_machine) do
    GenServer.start_link(@server, current_vending_machine, name: @server)
  end

  def insert_coin(coin) do
    GenServer.cast(@server, {:insert_coin, coin})
  end

  def select_product(product) do
    GenServer.cast(@server, {:select_product, product})
  end
end
