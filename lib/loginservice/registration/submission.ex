defmodule Loginservice.Registration.Submission do
  use Ecto.Schema
  import Ecto.Changeset


  schema "submissions" do

    field :responses, :string
    field :mail_confirmed, :boolean

    belongs_to :user, Loginservice.Auth.User
    belongs_to :campaign, Loginservice.Registration.Campaign
    has_many :mail_confirmations, Loginservice.Registration.MailConfirmation


    timestamps()
  end

  @doc false
  def changeset(submission, attrs) do
    submission
    |> cast(attrs, [:responses, :mail_confirmed, :user_id, :campaign_id])
    |> validate_required([:user_id, :campaign_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:campaign_id)
  end

end
