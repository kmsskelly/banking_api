import Config

config :banking_api, BankingApi.Repo,
  username: "banking_api_user",
  password: "banking_api_pass",
  database: "banking-api-db",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :banking_api_web, BankingApiWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :plug_init_mode, :runtime

config :phoenix, :stacktrace_depth, 20
