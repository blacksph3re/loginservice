defmodule Loginservice.Registration.Field do
  use Ecto.Schema
  import Ecto.Changeset


  schema "fields" do
    field :description, :string
    field :key, :string
    field :title, :string
    field :type, :string
    field :choices, :string
    field :campaign_id, :id

    timestamps()
  end

  @doc false
  def changeset(field, attrs) do
    field
    |> cast(attrs, [:title, :description, :key, :type, :choices, :campaign_id])
    |> validate_required([:title, :key, :type, :campaign_id])
    |> foreign_key_constraint(:campaign_id)
  end
end
