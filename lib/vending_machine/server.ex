defmodule VendingMachine.Server do
  use GenServer
  alias VendingMachine.Impl

  @doc """
  Starts the Vending Machine GenServer
  """
  def start_link(opts) do
    GenServer.start_link(VendingMachine.Server, %VendingMachine.Machine{}, opts)
  end

  def init(initial_vending_machine) do
    {:ok, initial_vending_machine}
  end

  def handle_cast({:insert_coin, coin}, current_vending_machine) do
    {:noreply, Impl.insert_coin(current_vending_machine, coin)}
  end

  def handle_cast({:select_product, product}, current_vending_machine) do
    {:noreply, Impl.select_product(current_vending_machine, product)}
  end

  def handle_call({:lookup, :display}, _from, current_vending_machine) do
    {new_vending_machine, display} = VendingMachine.Impl.check_display(current_vending_machine)
    {:reply, display, new_vending_machine}
  end
end
