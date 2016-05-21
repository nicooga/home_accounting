defmodule HomeAccounting.Repo.Migrations.AddIndexesToExpenditures do
  use Ecto.Migration

  def change do
    alter table(:expenditures) do
      remove :amount
      add :amount_cents, :integer
    end
  end
end
