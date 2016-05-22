defmodule HomeAccounting.Tag do
  use HomeAccounting.Web, :model
  alias HomeAccounting.Repo

  schema "tags" do
    field :name, :string
  end

  def get_by_name(name), do: Repo.get_by(__MODULE__, name: name)
end
