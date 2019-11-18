defmodule VendingMachine.Server do
  use GenServer

  @doc """
  Starts the Vending Machine GenServer
  """
  def start_link(opts) do
    GenServer.start_link(
      VendingMachine.Server,
      %VendingMachine.Machine{
        inventory: [
          VendingMachine.Product.createCola(),
          VendingMachine.Product.createChips(),
          VendingMachine.Product.createCandy()
        ]
      },
      opts
    )
  end

  def init(initial_vending_machine) do
    {:ok, initial_vending_machine}
  end

  def handle_cast({:insert_coin, coin}, current_vending_machine) do
    {:noreply, VendingMachine.Impl.insert_coin(current_vending_machine, coin)}
  end

  def handle_cast({:set_vending_machine, new_vending_machine}, _current_vending_machine) do
    {:noreply, new_vending_machine}
  end

  def handle_call({:select_product, product}, _from, current_vending_machine) do
    new_vending_machine = VendingMachine.Impl.select_product(current_vending_machine, product)
    {:reply, {new_vending_machine.bin, new_vending_machine.coin_return}, new_vending_machine}
  end

  def handle_call(:get_display, _from, current_vending_machine) do
    {new_vending_machine, display} = VendingMachine.Impl.check_display(current_vending_machine)
    {:reply, display, new_vending_machine}
  end

  def handle_call(:get_vending_machine, _from, current_vending_machine) do
    {:reply, current_vending_machine, current_vending_machine}
  end

  def handle_call(:return_coins, _from, current_vending_machine) do
    new_vending_machine = VendingMachine.Impl.return_coins(current_vending_machine)
    {:reply, new_vending_machine.coin_return, new_vending_machine}
  end
end
