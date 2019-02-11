# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :reserva,
  ecto_repos: [Reserva.Repo]

# Configures the endpoint
config :reserva, ReservaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tflwTeHWJJ2ZWi0ivB8n32dCyiPj11uJUGPR7E5zMhYcED0NZ+asFrW5KwMa4h+u",
  render_errors: [view: ReservaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Reserva.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
