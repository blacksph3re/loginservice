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
    |> cast(attrs, [:submission_id, :url])
    |> validate_required([:submission_id, :url])
    |> foreign_key_constraint(:submission_id)
    |> put_url_hash()
  end

    # Hash the url so an attacker with db read access can't create a user account for a mail he doesn't posess
  defp put_url_hash(%Ecto.Changeset{valid?: true, changes: %{url: url}} = changeset) do
    change(changeset, url: Loginservice.hash_without_salt(url))
  end
  defp put_url_hash(changeset), do: changeset
end
