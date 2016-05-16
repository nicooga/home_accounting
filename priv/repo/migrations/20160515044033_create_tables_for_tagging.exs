defmodule HomeAccounting.Repo.Migrations.CreateTablesForTagging do
  use Ecto.Migration

  def change do
    create table(:tags), do: add(:name, :string)

    create table(:expenditures_taggings) do
      add :assoc_id, references(:expenditures)
      add :tag_id, references(:tags)
    end

    create index(:expenditures_taggings, [
      :assoc_id,
      :tag_id
    ])
  end
end
