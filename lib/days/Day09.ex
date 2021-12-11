defmodule Aoc2021Ex.Day09 do
  use Aoc2021Ex.Day

  def solve1 do
    map = input_int_map()
    Enum.sum(Enum.map(lowpoints(map), &(Map.get(map, &1) + 1)))
  end

  def solve2 do
    map = input_int_map()

    Enum.map(lowpoints(map), fn pt -> length(expand_basin(map, [pt], [])) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def lowpoints(map) do
    Map.keys(map)
    |> Enum.filter(fn pos -> Enum.all?(neighbors(map, [pos]), &(map[pos] < map[&1])) end)
  end

  def expand_basin(_, [], basin_points), do: basin_points

  def expand_basin(map, new_points, basin_points) do
    basin_points = new_points ++ basin_points
    new_points = Enum.filter(neighbors(map, basin_points), &(Map.get(map, &1) != 9))
    expand_basin(map, new_points, basin_points)
  end

  def neighbors(map, points) do
    Enum.flat_map(points, fn {r, c} -> [{r + 1, c}, {r - 1, c}, {r, c + 1}, {r, c - 1}] end)
    |> Enum.uniq()
    |> Enum.filter(&(Map.has_key?(map, &1) && &1 not in points))
  end
end
