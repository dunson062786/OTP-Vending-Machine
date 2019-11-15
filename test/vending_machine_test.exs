defmodule VendingMachineTest do
  use ExUnit.Case, async: true
  doctest VendingMachine

  setup do
    vending_machine = start_supervised!(VendingMachine.Server)
    %{vending_machine: vending_machine}
  end

  test "displays INSERT COIN", %{vending_machine: vending_machine} do
    assert VendingMachine.get_display(vending_machine) == "INSERT COIN"
  end
end
