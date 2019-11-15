defmodule VendingMachine.Impl do
  @nickel 5.0
  @dime 2.268
  @quarter 5.670

  def insert_coin(vending_machine, coin) do
    case coin.weight do
      value when value in [@nickel, @dime, @quarter] ->
        vending_machine = put_in(vending_machine.staging, vending_machine.staging ++ [coin])
        put_in(vending_machine.display, get_value_of_coins(vending_machine.staging))

      _ ->
        put_in(vending_machine.coin_return, vending_machine.coin_return ++ [coin])
    end
  end

  def select_product(vending_machine, product) do
    selected = get_in(vending_machine, [Access.key(:grid), Access.key(product)])

    if selected do
      deselect_selected(vending_machine, product)
    else
      vending_machine
      |> select_item_in_grid(product)
      |> process_transaction()
    end
  end

  def check_display(vending_machine) do
    if vending_machine.display == nil do
      change_display(vending_machine)
    else
      {vending_machine, vending_machine.display}
    end
  end

  def remove_product_from_bin(vending_machine, product) do
    vending_machine = put_in(vending_machine.bin, vending_machine.bin -- [product])

    put_in(vending_machine.display, "INSERT COIN")
  end

  def deselect_selected(vending_machine, product) do
    %VendingMachine.Machine{
      vending_machine
      | grid: Map.replace!(vending_machine.grid, product, false)
    }
  end

  def get_value_of_coins(list) do
    Enum.reduce(list, 0, &(get_value_of_coin(&1) + &2))
  end

  def get_value_of_coin(coin) do
    case coin.weight do
      @nickel -> 0.05
      @dime -> 0.10
      @quarter -> 0.25
      _ -> 0
    end
  end

  def select_item_in_grid(vending_machine, product) do
    vending_machine = deselect_everything(vending_machine)
    put_in(vending_machine, [Access.key(:grid), Access.key(product)], true)
  end

  def deselect_everything(vending_machine) do
    put_in(
      vending_machine.grid,
      Enum.into(vending_machine.grid, %{}, fn {k, _v} -> {k, false} end)
    )
  end

  def process_transaction(vending_machine) do
    if sold_out(vending_machine) do
      vending_machine = deselect_everything(vending_machine)
      put_in(vending_machine.display, "SOLD OUT")
    else
      {price, display_price} =
        vending_machine
        |> get_selected()
        |> get_price()

      value_of_coins = get_value_of_coins(vending_machine.staging)

      if value_of_coins < price do
        put_in(vending_machine.display, "PRICE #{display_price}")
      else
        product = %Product{name: get_selected(vending_machine)}

        vending_machine =
          put_in(vending_machine.inventory, vending_machine.inventory -- [product])

        vending_machine = put_in(vending_machine.bin, vending_machine.bin ++ [product])
        put_in(vending_machine.display, "THANK YOU")
      end
    end
  end

  def sold_out(vending_machine) do
    selected = get_selected(vending_machine)
    Enum.empty?(Enum.filter(vending_machine.inventory, fn x -> x.name == selected end))
  end

  def get_selected(vending_machine) do
    case vending_machine.grid do
      %{cola: true, chips: false, candy: false} -> :cola
      %{cola: false, chips: true, candy: false} -> :chips
      %{cola: false, chips: false, candy: true} -> :candy
    end
  end

  def get_price(product) do
    case product do
      :cola -> {1.0, "$1.00"}
      :chips -> {0.5, "$0.50"}
      :candy -> {0.65, "$0.65"}
    end
  end

  def change_display(vending_machine) do
    if can_make_change(vending_machine) do
      {put_in(vending_machine.display, "INSERT COIN"), vending_machine.display || "INSERT COIN"}
    else
      {put_in(vending_machine.display, "EXACT CHANGE ONLY"),
       vending_machine.display || "EXACT CHANGE ONLY"}
    end
  end

  @doc """
  If the bank return any multiple of 5c up to 20c then there is enough money to make change
  since you could always return coins from staging until you get within that range.
  """
  def can_make_change(vending_machine) do
    number_of_nickels = vending_machine.bank.tally.nickel
    number_of_dimes = vending_machine.bank.tally.dime

    number_of_nickels > 3 || (number_of_nickels > 1 && number_of_dimes > 0) ||
      (number_of_nickels == 1 && number_of_dimes > 1)
  end
end
