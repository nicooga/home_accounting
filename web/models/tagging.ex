defmodule HomeAccounting.Tagging do
  use Ecto.Schema

  schema "abstract table: taggings" do
    field :assoc_id, :integer
    belongs_to :tag, HomeAccounting.Tag
  end
end
