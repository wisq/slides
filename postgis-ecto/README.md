# PostGIS + Ecto

## Installation

### 1: Add `geo_postgis` to dependencies

```elixir
      {:geo_postgis, "~> 2.0"}
```

### 2: Define types and add to repo config

```elixir
Postgrex.Types.define(
  MyApp.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Poison
)
```

```elixir
config :my_app, MyApp.Repo, types: MyApp.PostgresTypes
```

### 3: Add a `CREATE EXTENSION` migration

```elixir
  def up do
    execute("CREATE EXTENSION IF NOT EXISTS postgis")
  end

  def down do
    execute("DROP EXTENSION IF EXISTS postgis")
  end
```

### 4: Define your tables and schemas

```elixir
    create table("places") do
      add(:location, :geometry)
    end
```

```elixir
  schema "places" do
    field(:location, Geo.PostGIS.Geometry)
  end
```

### 5a: (optional) Constrain your locations

```elixir
  def up do
    execute("ALTER TABLE places ALTER COLUMN location TYPE geometry(Polygon, 4326)")
  end

  def down do
    execute("ALTER TABLE places ALTER COLUMN location TYPE geometry")
  end
```

### 5b: (optional) Create as constrained geometry

```elixir
    create table("places") do
      add(:location, :"geometry(Polygon, 4326)")
    end
```

## Usage

### Insert polygon

```elixir
%MyApp.Place{
  location: %Geo.Polygon{
    coordinates: [
      # Outer bounds (square):
      [{1, 1}, {1, 8}, {8, 8}, {8, 1}, {1, 1}],
      # Inner exclusion #1 (square):
      [{2, 2}, {2, 3}, {3, 3}, {3, 2}, {2, 2}],
      # Inner exclusion #2 (diamond):
      [{5, 5}, {6, 6}, {5, 7}, {4, 6}, {5, 5}]
    ],
    srid: 4326
  }
}
|> MyApp.Repo.insert()
```

### Select polygon

```elixir
import Ecto.Query

from(MyApp.Place, limit: 1)
|> MyApp.Repo.one()
|> Map.fetch!(:location)
```

```elixir
%Geo.Polygon{
  coordinates: [
    [{1.0, 1.0}, {1.0, 8.0}, {8.0, 8.0}, {8.0, 1.0}, {1.0, 1.0}],
    [{2.0, 2.0}, {2.0, 3.0}, {3.0, 3.0}, {3.0, 2.0}, {2.0, 2.0}],
    [{5.0, 5.0}, {6.0, 6.0}, {5.0, 7.0}, {4.0, 6.0}, {5.0, 5.0}]
  ],
  properties: %{},
  srid: 4326
}
```

### Query based on distance

```elixir
# Search within 200km of Ottawa:
point = %Geo.Point{
  # Remember, coordinates are {longitude, latitude} !
  # East and north are positive, west and south are negative.
  coordinates: {-75.6972, 45.4215},
  srid: 4326
}
metres = 200_000

# For select(), where(), and other query functions:
import Ecto.Query
# For st_distancesphere() and other GIS functions:
import Geo.PostGIS

MyApp.Place
|> select([p], {st_distancesphere(p.location, ^point), p})
|> where([p], st_distancesphere(p.location, ^point) <= ^metres)
|> order_by([p], st_distancesphere(p.location, ^point))
```
