defmodule Loginservice.Repo.Migrations.CreateFields do
  use Ecto.Migration

  def change do
    create table(:fields) do
      add :title, :string
      add :description, :string
      add :key, :string
      add :type, :string
      add :choices, :string
      add :campaign_id, references(:campaigns, on_delete: :nothing)

      timestamps()
    end

    create index(:fields, [:campaign_id])
  end
end
