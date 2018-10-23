defmodule GisDemo.Place do
  use Ecto.Schema
  import Ecto.Changeset

  schema "places" do
    timestamps()

    field(:title, :string)
    field(:location, Geo.PostGIS.Geometry)
  end

  @doc false
  def changeset(place, attrs) do
    place
    |> cast(attrs, [:title, :location])
    |> validate_required([:title, :location])
  end
end
