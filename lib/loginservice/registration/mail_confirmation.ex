defmodule Loginservice.Registration.MailConfirmation do
  use Ecto.Schema
  import Ecto.Changeset


  schema "mail_confirmations" do
    field :url, :string
    belongs_to :submission, Loginservice.Registration.Submission

    timestamps()
  end

  @doc false
  def changeset(mail_confirmation, attrs) do
    mail_confirmation
    |> cast(attrs, [:submission_id])
    |> validate_required([:submission_id])
    |> foreign_key_constraint(:submission_id)
    |> random_url()
  end

  defp random_url(changeset) do
    change(changeset, url: :crypto.strong_rand_bytes(32) |> Base.url_encode64 |> binary_part(0, 32))
  end
end
