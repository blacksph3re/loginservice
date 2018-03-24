defmodule LoginserviceWeb.LoginView do
  use LoginserviceWeb, :view
  alias LoginserviceWeb.LoginView

  def render("login.json", %{access: access, refresh: refresh}) do
    %{success: true,
      access_token: access,
      refresh_token: refresh}
  end

  def render("success.json", %{}) do
    %{success: true}
  end

  def render("user.json", %{user: user}) do
    %{success: true, data: render_one(user, LoginView, "user_data.json")}
  end

  def render("user_data.json", %{login: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email,
      inserted_at: user.inserted_at,
      superadmin: user.superadmin
    }
  end

  def render("user_existence.json", %{exists: exists}) do
    %{success: true,
      exists: exists}
  end
end
