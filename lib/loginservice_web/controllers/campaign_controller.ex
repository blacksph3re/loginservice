defmodule LoginserviceWeb.CampaignController do
  use LoginserviceWeb, :controller

  alias Loginservice.Registration
  alias Loginservice.Registration.Campaign

  action_fallback LoginserviceWeb.FallbackController

  defp check_admin(conn, action, campaign \\ nil) do
    case Loginservice.Interfaces.CampaignAuthorization.authorize_action(action, conn.assigns.user, campaign) do
      true -> {:ok}
      false -> {:forbidden, "You don't have the necessary permissions to " <> Kernel.inspect(action) <> " campaigns"}
    end
  end

  def index(conn, _params) do
    campaigns = Registration.list_campaigns()
    render(conn, "index.json", campaigns: campaigns)
  end

  def create(conn, %{"campaign" => campaign_params}) do
    with {:ok} <- check_admin(conn, :create),
        {:ok, %Campaign{} = campaign} <- Registration.create_campaign(campaign_params) do
      conn
      |> put_status(:created)
      |> render("show.json", campaign: campaign)
    end
  end

  def show(conn, %{"campaign_url" => campaign_url}) do
    campaign = Registration.get_campaign_by_url!(campaign_url)
    render(conn, "show.json", campaign: campaign)
  end

  def update(conn, %{"id" => id, "campaign" => campaign_params}) do
    campaign = Registration.get_campaign!(id)

    with {:ok} <- check_admin(conn, :update, campaign),
        {:ok, %Campaign{} = campaign} <- Registration.update_campaign(campaign, campaign_params) do
      render(conn, "show.json", campaign: campaign)
    end
  end

  def delete(conn, %{"id" => id}) do
    campaign = Registration.get_campaign!(id)
    with {:ok} <- check_admin(conn, :delete, campaign),
        {:ok, %Campaign{}} <- Registration.delete_campaign(campaign) do
      send_resp(conn, :no_content, "")
    end
  end

  # Submit a new user registration
  def submit(conn, %{"campaign_url" => campaign_url, "submission" => submission_params}) do
    campaign = Registration.get_campaign_by_url!(campaign_url)
    with {:ok, user} <- Loginservice.Auth.create_user(%{email: submission_params["email"], name: submission_params["name"], password: submission_params["password"]}),
         {:ok, submission} <- Registration.create_submission(campaign, user, submission_params["responses"]),
         {:ok, _data} <- Registration.send_confirmation_mail(user, submission) do
      conn
      |> put_status(:created)
      |> render("success.json")
    end
    # TODO remove created user or submission in case the submission failed later in the pipeline
  end

  # Confirm a users mail because he clicked the right link
  def confirm_mail(conn, %{"confirmation_url" => confirmation_url}) do
    confirmation = Registration.get_confirmation_by_url!(confirmation_url)
    with {:ok} <- Registration.confirm_mail(confirmation) do
      render(conn, "success.json")
    end
  end
end
