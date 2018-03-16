defmodule Loginservice.Repo.Migrations.CreateSubmissions do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :responses, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :campaign_id, references(:campaigns, on_delete: :nothing)

      timestamps()
    end

    create index(:submissions, [:campaign_id])
    create index(:submissions, [:user_id])
  end
end
