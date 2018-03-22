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
  url_prefix: "www.alastair.com/registration/",
  ttl_refresh: 60 * 60 * 24 * 7 * 2, # 2 weeks
  ttl_access: 60 * 60, # 1 hour
  ttl_password_reset: 60 * 15, # 15 Minutes
  ttl_mail_confirmation: 60 * 60 * 2 # 2 hours

defmodule Helper do
  def read_secret_from_file(nil, fallback), do: fallback
  def read_secret_from_file(file, fallback) do
    case File.read(file) do
      {:ok, content} -> content
      {:error, _} -> fallback
    end
  end
end

# Configures the endpoint
config :loginservice, LoginserviceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Hsyt09GyUmlL+7sSas8Wyw2NjPArMRO1KUyLuE4dgIXkBwB59rVsLmDC+x6URN/o",
  render_errors: [view: LoginserviceWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Loginservice.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :loginservice, Loginservice.Interfaces.Mail,
  from: "alastair@nico-westerbeck.de",
  sendgrid_key: Helper.read_secret_from_file(System.get_env("SENDGRID_KEY_FILE"), "censored")

config :loginservice, Loginservice.Auth.Guardian,
  issuer: System.get_env("JWT_ISSUER") || "Alastair", 
  secret_key: Helper.read_secret_from_file(System.get_env("JWT_SECRET_KEY_FILE"), "rrSTfyfvFlFj1JCl8QW/ritOLKzIncRPC5ic0l0ENVUoiSIPBCDrdU6Su5vZHngY")



# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
