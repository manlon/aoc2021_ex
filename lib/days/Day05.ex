defmodule Aoc2021Ex.Day05 do
  use Aoc2021Ex.Day

  def solve1 do
    count_overlaps(ortho_points())
  end

  def solve2 do
    count_overlaps(ortho_points() ++ diag_points())
  end

  def ortho_lines do
    parse_input()
    |> Enum.filter(fn {{x1, y1}, {x2, y2}} ->
      x1 == x2 || y1 == y2
    end)
  end

  def ortho_points do
    ortho_lines()
    |> Enum.flat_map(&expand_ortho/1)
  end

  def diag_lines do
    parse_input()
    |> Enum.filter(fn {{x1, y1}, {x2, y2}} ->
      abs(x1 - x2) == abs(y1 - y2)
    end)
  end

  def diag_points do
    diag_lines()
    |> Enum.flat_map(&expand_diag/1)
  end

  def expand_ortho({{x1, y1}, {x2, y2}}) do
    for x <- x1..x2 do
      for y <- y1..y2 do
        {x, y}
      end
    end
    |> List.flatten()
  end

  def expand_diag({{x1, y1}, {x2, y2}}) do
    Enum.zip(x1..x2, y1..y2)
  end

  def count_overlaps(points) do
    Enum.reduce(points, %{}, fn pt, map ->
      Map.update(map, pt, 1, &(&1 + 1))
    end)
    |> Enum.count(fn {_, v} -> v > 1 end)
  end

  def parse_input do
    input_lines()
    |> Enum.map(fn line ->
      String.split(line, " -> ")
      |> Enum.map(&comma_int_list/1)
      |> Enum.map(&List.to_tuple/1)
    end)
    |> Enum.map(&List.to_tuple/1)
  end

  def print_map(map) do
    keys = Map.keys(map)
    maxx = Enum.map(keys, fn {x, _} -> x end) |> Enum.max()
    maxy = Enum.map(keys, fn {_, y} -> y end) |> Enum.max()

    for y <- 0..maxy do
      for x <- 0..maxx do
        Map.get(map, {x, y}, ".")
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
    |> IO.puts()
    map
  end
end
