defmodule Loginservice.Registration.Submission do
  use Ecto.Schema
  import Ecto.Changeset


  schema "submissions" do

    field :responses, :string
    field :user_id, :id
    field :campaign_id, :id

    timestamps()
  end

  @doc false
  def changeset(submission, attrs) do
    submission
    |> cast(attrs, [:responses, :user_id, :campaign_id])
    |> validate_required([:responses, :user_id, :campaign_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:campaign_id)
  end

end
