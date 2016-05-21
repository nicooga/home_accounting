use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :home_accounting, HomeAccounting.Endpoint,
  secret_key_base: "afAf2zGeMt2vaTlEZxvHuhIlj8ZeX/CXNX4kUBrXv6eMzcV6S/4O2s3+C0++H5xm"

# Configure your database
config :home_accounting, HomeAccounting.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "home_accounting_prod",
  pool_size: 20
