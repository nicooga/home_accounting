defmodule HomeAccounting.Tag do
  use HomeAccounting.Web, :model

  schema "tags" do
    field :name, :string
  end

  def find_by_name(query, tag_name) do
    from t in query, where: t.name == ^tag_name
  end
end
