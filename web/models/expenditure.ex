defmodule HomeAccounting.Expenditure do
  use HomeAccounting.Web, :model

  alias Monetized.Money
  alias HomeAccounting.{Tagging, Tag}

  schema "expenditures" do
    field :desc, :string
    field :amount, Money, default: Money.zero
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


  @required_fields ~w(desc amount expent_at)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
