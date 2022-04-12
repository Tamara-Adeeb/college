# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :college,
  ecto_repos: [College.Repo]

# Configures the endpoint
config :college, CollegeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "M0hZaSPoWP4ED404p4fxM4tDH5bizWh7r8kN8CRTqVSlT6jeyD1gOVDwutgCMBo7",
  render_errors: [view: CollegeWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: College.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :college, College.Authentication.Guardian,
  issuer: "college",
  secret_key: "mysecretkey"
