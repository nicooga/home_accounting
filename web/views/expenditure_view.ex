defmodule HomeAccounting.ExpenditureView do
  use HomeAccounting.Web, :view

  def render("index.json", %{expenditures: expenditures}) do
    %{data: render_many(expenditures, HomeAccounting.ExpenditureView, "expenditure.json")}
  end

  def render("show.json", %{expenditure: expenditure}) do
    %{data: render_one(expenditure, HomeAccounting.ExpenditureView, "expenditure.json")}
  end

  def render("expenditure.json", %{expenditure: expenditure}) do
    %{id: expenditure.id,
      desc: expenditure.desc,
      amount: expenditure.amount}
  end
end
