defmodule LoginserviceWeb.LoginController do
  use LoginserviceWeb, :controller

  alias Loginservice.Auth

  action_fallback LoginserviceWeb.FallbackController

  def login(conn, %{"username" => username, "password" => password}) do
    with {:ok, _user, access, refresh} <- Auth.login_user(username, password) do
      render(conn, "login.json", access: access, refresh: refresh)
    end
  end

  def logout(conn, _params) do
    with {:ok, _token} <- Auth.logout_token(conn.assigns.refresh_token_id) do
      render(conn, "success.json")
    end
  end

  def renew_token(conn, %{"refresh_token" => token}) do
    with {:ok, access} <- Auth.renew_token(token) do
      render(conn, "login.json", access: access, refresh: "unchanged")
    else
      _ -> {:forbidden, "Invalid refresh token"}
    end
  end

  def user_data(conn, _params) do
    render(conn, "user.json", conn.assigns.user)
  end

  def check_user_existence(conn, %{"username" => username}) do
    render(conn, "user_existence.json", exists: Auth.check_user_existence(username))
  end
end
