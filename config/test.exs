import Config

config :banking_api, BankingApi.Repo,
  username: "banking_api_user",
  password: "banking_api_pass",
  database: "banking_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("DB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :banking_api_web, BankingApiWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
