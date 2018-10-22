square = %GisDemo.Place{
  title: "square with exclusions",
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

polygon = %GisDemo.Place{
  title: "irregular polygon",
  location: %Geo.Polygon{
    coordinates: [
      # Outer bounds:
      [{-35, -10}, {-45, -45}, {-15, -40}, {-10, -20}, {-35, -10}],
      # Inner exclusion:
      [{-20, -30}, {-35, -35}, {-30, -20}, {-20, -30}]
    ],
    srid: 4326
  }
}

multipolygon = %GisDemo.Place{
  title: "multipolygon",
  location: %Geo.MultiPolygon{
    coordinates: [
      # First polygon:
      [[{40.0, 40.0}, {20.0, 45.0}, {45.0, 30.0}, {40.0, 40.0}]],
      # Second polygon:
      [
        # Outer bounds:
        [{20.0, 35.0}, {10.0, 30.0}, {10.0, 10.0}, {30.0, 5.0}, {45.0, 20.0}, {20.0, 35.0}],
        # Inner exclusion:
        [{30.0, 20.0}, {20.0, 15.0}, {20.0, 25.0}, {30.0, 20.0}]
      ]
    ],
    srid: 4326
  }
}

places = [
  square,
  polygon,
  multipolygon
]

GisDemo.Repo.transaction(fn ->
  GisDemo.Repo.delete_all(GisDemo.Place)

  Enum.each(places, fn place ->
    {:ok, record} = GisDemo.Repo.insert(place)
    IO.puts("Inserted: #{record.title}")
  end)
end)
