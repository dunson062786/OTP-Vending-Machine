defmodule VendingMachine.ProductTest do
  use ExUnit.Case
  doctest VendingMachine.Product

  test "VendingMachine.Product.createCola/0" do
    assert VendingMachine.Product.createCola() == %VendingMachine.Product{name: :cola}
  end

  test "VendingMachine.Product.createChips/0" do
    assert VendingMachine.Product.createChips() == %VendingMachine.Product{name: :chips}
  end

  test "VendingMachine.Product.createCandy/0" do
    assert VendingMachine.Product.createCandy() == %VendingMachine.Product{name: :candy}
  end
end
