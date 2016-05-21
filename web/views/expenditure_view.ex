defmodule HomeAccounting.ExpenditureView do
  use HomeAccounting.Web, :view
  use JaSerializer.PhoenixView

  attributes [:desc, :amount, :expent_at, :tag_names]

  def amount(expenditure, _conn) do
    expenditure.amount_cents && expenditure.amount_cents / 100
  end

  def tag_names(expenditure, _conn) do
    expenditure
    |> Repo.preload(:tags)
    |> fn(e)->
      Enum.map(e.tags, &(&1.name))
    end.()
  end
end
