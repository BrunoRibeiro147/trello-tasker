defmodule TrelloTasker.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :path, :string

      timestamps()
    end
    create unique_index(:cards, [:path])
  end
end
