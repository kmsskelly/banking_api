import Config

config :banking_api,
  ecto_repos: [BankingApi.Repo]

config :banking_api_web,
  ecto_repos: [BankingApi.Repo],
  generators: [context_app: :banking_api, binary_id: true]

config :banking_api_web, BankingApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1Yj10bWYcZ6lxHFWsx3+ewMXIur1o0JFyJhiJc9Hw0aZqmOoQp2g6sWulg092+7r",
  render_errors: [view: BankingApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BankingApi.PubSub,
  live_view: [signing_salt: "DY9Zmwk0"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
