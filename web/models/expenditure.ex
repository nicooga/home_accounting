defmodule HomeAccounting.Expenditure do
  use HomeAccounting.Web, :model
  alias HomeAccounting.{Tagging}

  schema "expenditures" do
    field :desc, :string
    field :amount_cents, :integer
    field :expent_at, Ecto.Date

    has_many(
      :taggings,
      {"expenditures_taggings", Tagging},
      foreign_key: :assoc_id,
      on_delete: :delete_all
    )
    has_many :tags, through: [:taggings, :tag], on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(desc amount_cents expent_at)
  @optional_fields ~w()

  def changeset(model, raw_params \\ :empty) do
    model
    |> cast(process_params(raw_params), @required_fields, @optional_fields)
  end

  defp process_params(raw_params) do
    case raw_params do
      %{"amount"=>arg} ->
        number = cond do
          is_binary(arg) ->
            {float,_} = Float.parse(arg)
            float
          is_number(arg) -> arg
        end

        raw_params
        |> Map.put("amount_cents", round(number * 100))
        |> Map.delete("amount")
      _ -> raw_params
    end
  end
end
