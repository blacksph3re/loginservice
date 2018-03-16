defmodule Loginservice.Repo.Migrations.CreateRefreshTokens do
  use Ecto.Migration

  def change do
    create table(:refresh_tokens) do
      add :token, :text, null: false
      add :device, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:refresh_tokens, [:user_id])
    create index(:refresh_tokens, [:token])
  end
end
