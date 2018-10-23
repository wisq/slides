# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :gis_demo,
  ecto_repos: [GisDemo.Repo]

config :gis_demo, GisDemo.Repo, types: GisDemo.PostgresTypes

# Configures the endpoint
config :gis_demo, GisDemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FpU1rSRr4PzhoxF+PN8iPPDqrXR4ne5u7MBFGLhQWejER8HzfzEIEZFZp4aWD46g",
  render_errors: [view: GisDemoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GisDemo.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
