defmodule HomeAccounting.Repo.Migrations.AddDateToExpenditures do
  use Ecto.Migration

  def change do
    alter table(:expenditures) do
      add :expent_at, :date
    end
  end
end
