defmodule HomeAccounting.Expenditure do
  use HomeAccounting.Web, :model

  alias Monetized.Money
  alias HomeAccounting.{Tagging, Tag}

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

  def search(query, search_term) when search_term == "", do: query
  def search(query, search_term) do
    from(e in query,
      where: fragment("? % ?", e.desc, ^search_term),
      order_by: fragment("similarity(?, ?) DESC", e.desc, ^search_term))
  end

  def search_expent_at_gteq(query, float) do
    from(e in select_amount_as_float(query),
      where: fragment("amount_float >= ?", ^float))
  end

  defp select_amount_as_float(query) do
    from(e in query,
      select: fragment("replace(substring(? from '\d+,\d+'), ',', '.')::float AS amount_float", e.amount))
  end

  @required_fields ~w(desc amount_cents expent_at)
  @optional_fields ~w()

  def changeset(model, raw_params \\ :empty) do
    model
    |> cast(process_params(raw_params), @required_fields, @optional_fields)
  end

  defp process_params(raw_params) do
    case raw_params do
      %{"amount"=>amount} when is_binary(amount) ->
        case Float.parse(amount) do
          {float, _} when is_float(float) ->
            raw_params
            |> Map.put("amount_cents", round(float * 100))
            |> Map.delete("amount")
          _ -> raw_params
        end
      _ -> raw_params
    end
  end
end
