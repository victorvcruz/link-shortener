defmodule LinkShortener.Repo.Migrations.CreateLinksTable do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :hash, :string, null: false
      add :url, :string, null: false
      add :clicks, :integer, default: 0
      add :created_at, :utc_datetime, null: false
      add :updated_at, :utc_datetime, null: false
    end

    create unique_index(:links, [:hash])
  end
end
