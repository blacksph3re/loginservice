defmodule Loginservice.ExpireTokens do
  use GenServer
  import Ecto.Query, warn: false


  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    expire_mail_confirmations()
    expire_password_resets()

    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  def expire_mail_confirmations() do
    # Pipeline of death to find a date in the past
    expiry = Loginservice.ecto_date_in_past(2 * 60 * 60) # Mail confirmation expires after 2 hours 
    query = from u in Loginservice.Registration.MailConfirmation,
      where: u.inserted_at < ^expiry

    Loginservice.Repo.delete_all(query)
  end

  def expire_password_resets() do
    expiry = Loginservice.ecto_date_in_past(15 * 60) # Password reset expires after 15 minutes
    query = from u in Loginservice.Auth.PasswordReset,
      where: u.inserted_at < ^expiry

    Loginservice.Repo.delete_all(query)
  end


  defp schedule_work() do
    Process.send_after(self(), :work, 5 * 60 * 1000) # Every 5 minutes
  end
end