defmodule Loginservice.Interfaces.CampaignAuthorization do
  def authorize_action(action, user, campaign \\ nil) do
    provider = Application.get_env(:loginservice, Loginservice.Interfaces.CampaignAuthorization)[:authorization_provider]
    apply(Loginservice.Interfaces.CampaignAuthorization, provider, [action, user, campaign])
  end

  def superadmin_only(_action, user, _campaign) do
    user.superadmin
  end
end