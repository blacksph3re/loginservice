defmodule Loginservice.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :password, :string
      add :active, :boolean, default: false, null: false
      add :superadmin, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:name])
    create unique_index(:users, [:email])
  end
end
