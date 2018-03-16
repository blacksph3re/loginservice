defmodule LoginserviceWeb.CampaignController do
  use LoginserviceWeb, :controller

  alias Loginservice.Registration
  alias Loginservice.Registration.Campaign

  action_fallback LoginserviceWeb.FallbackController

  def index(conn, _params) do
    campaigns = Registration.list_campaigns()
    render(conn, "index.json", campaigns: campaigns)
  end

  def create(conn, %{"campaign" => campaign_params}) do
    with {:ok, %Campaign{} = campaign} <- Registration.create_campaign(campaign_params) do
      conn
      |> put_status(:created)
      |> render("show.json", campaign: campaign)
    end
  end

  def show(conn, %{"id" => id}) do
    campaign = Registration.get_campaign!(id)
    render(conn, "show.json", campaign: campaign)
  end

  def update(conn, %{"id" => id, "campaign" => campaign_params}) do
    campaign = Registration.get_campaign!(id)

    with {:ok, %Campaign{} = campaign} <- Registration.update_campaign(campaign, campaign_params) do
      render(conn, "show.json", campaign: campaign)
    end
  end

  def delete(conn, %{"id" => id}) do
    campaign = Registration.get_campaign!(id)
    with {:ok, %Campaign{}} <- Registration.delete_campaign(campaign) do
      send_resp(conn, :no_content, "")
    end
  end
end
