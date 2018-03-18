defmodule Loginservice.Repo.Migrations.CreateMailConfirmations do
  use Ecto.Migration

  def change do
    create table(:mail_confirmations) do
      add :url, :string
      add :submission_id, references(:submissions, on_delete: :nothing)

      timestamps()
    end

    create index(:mail_confirmations, [:submission_id])
  end
end
