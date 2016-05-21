defmodule HomeAccounting.Repo.Migrations.AddSearch do
  use Ecto.Migration

  def up do
    execute "CREATE extension if not exists pg_trgm;"
    execute "CREATE INDEX asdf ON expenditures USING gin(\"desc\" gin_trgm_ops);"
  end

  def down do
    execute "DROP INDEX expenditures_desc_trgm_index;"
  end
end
