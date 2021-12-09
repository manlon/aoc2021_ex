defmodule Aoc2021Ex.Day09 do
  use Aoc2021Ex.Day

  def solve1 do
    map = input_map()

    Enum.map(lowpoints(map), fn pos -> Map.get(map, pos) + 1 end)
    |> Enum.sum()
  end

  def solve2 do
    map = input_map()

    Enum.map(lowpoints(map), fn pt -> length(expand_basin(map, [pt])) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def lowpoints(map) do
    Enum.filter(Map.keys(map), fn pos -> is_lowpoint?(map, pos) end)
  end

  def is_lowpoint?(map, pos) do
    neighbors(map, pos)
    |> Enum.all?(fn neighb -> Map.get(map, pos) < Map.get(map, neighb) end)
  end

  def expand_basin(map, basin_points) do
    new_neighbors = Enum.flat_map(basin_points, fn pt -> neighbors(map, pt) end)

    new_points =
      (Enum.uniq(new_neighbors) -- basin_points)
      |> Enum.filter(fn pt -> Map.get(map, pt) != 9 end)

    if new_points == [] do
      basin_points
    else
      expand_basin(map, basin_points ++ new_points)
    end
  end

  def neighbors(map, {r, c}) do
    [{r + 1, c}, {r - 1, c}, {r, c + 1}, {r, c - 1}]
    |> Enum.filter(fn pos -> Map.has_key?(map, pos) end)
  end

  def input_map do
    input_lines()
    |> Enum.map(fn line ->
      String.graphemes(line)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, lineno}, map ->
      Enum.reduce(Enum.with_index(line), map, fn {val, colno}, map ->
        Map.put(map, {lineno, colno}, val)
      end)
    end)
  end
end
