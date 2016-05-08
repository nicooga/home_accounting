defmodule HomeAccounting.Expenditure do
  use HomeAccounting.Web, :model

  alias Monetized.Money

  schema "expenditures" do
    field :desc, :string
    field :amount, Money, default: Money.zero

    timestamps
  end

  @required_fields ~w(desc amount)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
