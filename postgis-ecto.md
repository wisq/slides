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

### 3: Add a `CREATE EXTENSION postgis` migration

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

### 5: (optional) Constrain your locations

```elixir
  def up do
    execute("ALTER TABLE places ALTER COLUMN location TYPE geometry(Polygon, 4326)")
  end

  def down do
    execute("ALTER TABLE places ALTER COLUMN location TYPE geometry")
  end
```
