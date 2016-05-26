defmodule HomeAccounting.Repo.Migrations.AddSearch do
  use Ecto.Migration

  @index_name "expenditures_desc_trgm_index"

  def up do
    execute "CREATE extension if not exists pg_trgm;"
    execute ~s/
      CREATE INDEX #{@index_name}
      ON expenditures
      USING gin("desc" gin_trgm_ops);
    /
  end

  def down do
    execute "DROP INDEX #{@index_name}"
  end
end
