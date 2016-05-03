defmodule HomeAccounting.Repo.Migrations.CreateExpenditure do
  use Ecto.Migration

  def change do
    create table(:expenditures) do
      add :desc, :text
      add :amount, :string

      timestamps
    end

  end
end
