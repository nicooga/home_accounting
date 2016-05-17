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

  @required_fields ~w(desc amount expent_at)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end

 #alias HomeAccounting.{Repo, Expenditure, Tag, Tagging}
 #import Ecto.Query, only: [from: 2]
 #import Ecto, only: [build_assoc: 2, build_assoc: 3]
