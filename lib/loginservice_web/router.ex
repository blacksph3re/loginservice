defmodule LoginserviceWeb.Router do
  use LoginserviceWeb, :router

#  pipeline :browser do
#    plug :accepts, ["html"]
#    plug :fetch_session
#    plug :fetch_flash
#    plug :protect_from_forgery
#    plug :put_secure_browser_headers
#  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Loginservice.Plugs.Auth
  end

  scope "/api", LoginserviceWeb do
    pipe_through :api # Use the default browser stack

    get "/status", LoginController, :status

    post "/login", LoginController, :login
    post "/renew", LoginController, :renew_token
    get "/user_existence", LoginController, :check_user_existence
    post "/password_reset", LoginController, :password_reset
    post "/confirm_reset_password/:reset_url", LoginController, :confirm_password_reset

    get "/campaigns", CampaignController, :index
    get "/campaigns/:campaign_url", CampaignController, :show
    post "/campaigns/:campaign_url", CampaignController, :submit
    post "/confirm_mail/:confirmation_url", CampaignController, :confirm_mail
  end

  scope "/api", LoginserviceWeb do
    pipe_through [:api, :authenticated]

    get "/user", LoginController, :user_data
    post "/logout", LoginController, :logout

    post "/campaigns", CampaignController, :create
    put "/campaigns/:id", CampaignController, :update
    delete "/campaigns/:id", CampaignController, :delete
  end

end
