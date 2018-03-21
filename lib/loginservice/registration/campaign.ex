defmodule Loginservice.Registration.Campaign do
  use Ecto.Schema
  import Ecto.Changeset


  schema "campaigns" do
    field :active, :boolean, default: false
    field :callback_url, :string
    field :name, :string
    field :description_short, :string
    field :description_long, :string
    field :url, :string

    has_many(:fields, Loginservice.Registration.Field, on_replace: :delete, on_delete: :delete_all)
    has_many(:submissions, Loginservice.Registration.Submission)

    timestamps()
  end

  @doc false
  def changeset(campaign, attrs) do
    campaign
    |> cast(attrs, [:name, :url, :active, :callback_url, :description_long, :description_short])
    |> validate_required([:name, :url, :active, :description_short])
    |> validate_format(:url, ~r/^[A-Za-z0-9_-]*$/)
    |> unique_constraint(:url)
  end
end
