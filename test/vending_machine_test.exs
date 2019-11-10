defmodule VendingMachineTest do
  use ExUnit.Case
  doctest VendingMachine

  test "greets the world" do
    assert VendingMachine.hello() == :world
  end
end
