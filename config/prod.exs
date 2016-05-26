use Mix.Config


config :home_accounting, HomeAccounting.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  url: [scheme: "https", host: "polar-river-91667.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  http: [port: {:system, "PORT"}]

config :home_accounting, HomeAccounting.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 20,
  ssl: true,
  database: "home_accounting_prod"

config :logger, level: :debug
