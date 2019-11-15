defmodule VendingMachine.Product do
  defstruct [:name]

  def createCola() do
    %VendingMachine.Product{name: :cola}
  end

  def createChips() do
    %VendingMachine.Product{name: :chips}
  end

  def createCandy() do
    %VendingMachine.Product{name: :candy}
  end
end
