defmodule Loginservice.Repo.Migrations.CreateCampaigns do
  use Ecto.Migration

  def change do
    create table(:campaigns) do
      add :name, :string
      add :url, :string, null: false
      add :active, :boolean, default: false, null: false
      add :description_short, :string, size: 400
      add :description_long, :text
      add :callback_url, :string

      timestamps()
    end

    create unique_index(:campaigns, [:url])
  end
end
