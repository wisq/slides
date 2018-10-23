defmodule GisDemo.Repo.Migrations.CreatePlaces do
  use Ecto.Migration

  def change do
    create table(:places) do
      timestamps()

      add :title, :string, null: false
      add :location, :geometry, null: false
    end
  end
end
