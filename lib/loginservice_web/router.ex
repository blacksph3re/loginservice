defmodule LoginserviceWeb.Router do
  use LoginserviceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Loginservice.Plugs.Auth
  end

  scope "/api", LoginserviceWeb do
    pipe_through :api # Use the default browser stack

    post "/login", LoginController, :login
    post "/renew", LoginController, :renew_token
    get "/user_existence", LoginController, :check_user_existence
    get "/campaigns", CampaignController, :index
    get "/campaigns/:id", CampaignController, :show
  end

  scope "/api", LoginserviceWeb do
    pipe_through [:api, :authenticated]

    get "/user", LoginController, :user_data
    post "/logout", LoginController, :logout

    post "/campaigns", CampaignController, :create
    put "/campaigns/:id", CampaignController, :update
    delete "/campaigns/:id", CampaignController, :delete
  end

  scope "/", LoginserviceWeb do
    pipe_through :browser

    get "/signup/:campaign_url", CampaignController, :signup
  end

end
