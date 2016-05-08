defmodule HomeAccounting.ExpenditureView do
  use HomeAccounting.Web, :view
  use JaSerializer.PhoenixView

  attributes [:desc, :amount]
end
