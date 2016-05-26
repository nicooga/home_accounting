defmodule HomeAccounting.TagView do
  use HomeAccounting.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name]
end
