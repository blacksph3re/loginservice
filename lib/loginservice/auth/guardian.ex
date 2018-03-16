## lib/auth_ex/auth/guardian.ex

defmodule Loginservice.Auth.Guardian do
  use Guardian, otp_app: :loginservice
  alias Loginservice.Auth

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(claims) do
    user = Auth.get_user!(claims["sub"])
    {:ok, user}
    # If something goes wrong here return {:error, reason}
  end
end