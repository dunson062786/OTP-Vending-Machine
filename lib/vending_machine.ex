defmodule VendingMachine do
  def insert_coin(server, coin) do
    GenServer.cast(server, {:insert_coin, coin})
  end

  def select_product(server, product) do
    GenServer.call(server, {:select_product, product})
  end

  def get_display(server) do
    GenServer.call(server, :get_display)
  end

  def return_coins(server) do
    GenServer.call(server, :return_coins)
  end

  def set_vending_machine(server, vending_machine) do
    GenServer.cast(server, {:set_vending_machine, vending_machine})
  end

  def get_vending_machine(server) do
    GenServer.call(server, :get_vending_machine)
  end
end
