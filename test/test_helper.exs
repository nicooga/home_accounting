ExUnit.start

Mix.Task.run "ecto.create", ~w(-r HomeAccounting.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r HomeAccounting.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(HomeAccounting.Repo)

