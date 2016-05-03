defmodule HomeAccounting.ExpenditureTest do
  use HomeAccounting.ModelCase

  alias HomeAccounting.Expenditure

  @valid_attrs %{amount: "some content", desc: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Expenditure.changeset(%Expenditure{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Expenditure.changeset(%Expenditure{}, @invalid_attrs)
    refute changeset.valid?
  end
end
