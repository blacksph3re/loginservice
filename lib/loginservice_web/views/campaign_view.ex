defmodule LoginserviceWeb.CampaignView do
  use LoginserviceWeb, :view
  alias LoginserviceWeb.CampaignView

  def render("index.json", %{campaigns: campaigns}) do
    %{data: render_many(campaigns, CampaignView, "campaign.json")}
  end

  def render("show.json", %{campaign: campaign}) do
    %{data: render_one(campaign, CampaignView, "campaign.json")}
  end

  def render("success.json", %{}) do
    %{success: true}
  end

  def render("campaign.json", %{campaign: campaign}) do
    %{id: campaign.id,
      name: campaign.name,
      url: campaign.url,
      active: campaign.active,
      description_short: campaign.description_short,
      description_long: campaign.description_long,
      callback_url: campaign.callback_url}
  end
end
