defmodule HomeAccounting.ExpenditureView do
  use HomeAccounting.Web, :view
  use JaSerializer.PhoenixView

  attributes [:desc, :amount, :expent_at]

  def amount(expenditure, _conn) do
    expenditure.amount && expenditure.amount.value
  end
end
