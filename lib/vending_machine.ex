defmodule VendingMachine do
  def insert_coin(server, coin) do
    GenServer.cast(server, {:insert_coin, coin})
  end

  def select_product(server, product) do
    GenServer.cast(server, {:select_product, product})
  end

  def get_display(server) do
    GenServer.call(server, {:lookup, :display})
  end
end
