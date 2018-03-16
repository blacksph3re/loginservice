defmodule LoginserviceWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use LoginserviceWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(LoginserviceWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(LoginserviceWeb.ErrorView, :"404")
  end

  def call(conn, {:error, msg}) do
    conn
    |> put_status(:bad_request)
    |> render(LoginserviceWeb.ErrorView, "error.json", msg: msg)
  end

  def call(conn, {:forbidden, msg}) do
    conn
    |> put_status(:forbidden)
    |> render(LoginserviceWeb.ErrorView, "error.json", msg: msg)
  end
end
