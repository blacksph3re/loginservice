# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :loginservice,
  ecto_repos: [Loginservice.Repo],
  env: Mix.env,
  url_prefix: "www.alastair.com/registration/"


# Configures the endpoint
config :loginservice, LoginserviceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Hsyt09GyUmlL+7sSas8Wyw2NjPArMRO1KUyLuE4dgIXkBwB59rVsLmDC+x6URN/o",
  render_errors: [view: LoginserviceWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Loginservice.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :loginservice, Loginservice.Interfaces.Mail,
  from: "alastair@nico-westerbeck.de",
  sendgrid_key: "censored"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
