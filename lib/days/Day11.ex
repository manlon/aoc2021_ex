defmodule Aoc2021Ex.Day11 do
  use Aoc2021Ex.Day

  def solve1 do
    step(input_int_map(), 0, 0, fn n, _ -> n == 100 end)
    |> then(&elem(&1, 1))
  end

  def solve2 do
    map = input_int_map()
    size = Enum.count(map)

    step(map, 0, 0, fn _, ct -> ct == size end)
    |> then(&elem(&1, 0))
  end

  def step(map, n, flashed_count, stop_cond) do
    n = n + 1
    map = Map.map(map, fn {_, v} -> v + 1 end)
    {map, new_flashed} = resolve_flashes(map)
    new_flashed_count = length(new_flashed)
    flashed_count = flashed_count + new_flashed_count

    if stop_cond.(n, new_flashed_count) do
      {n, flashed_count}
    else
      map = for pt <- new_flashed, reduce: map, do: (map -> Map.put(map, pt, 0))
      step(map, n, flashed_count, stop_cond)
    end
  end

  def resolve_flashes(map, acc \\ []) do
    case for {pos, v} <- map, v >= 10, pos not in acc, do: pos do
      [] ->
        {map, acc}

      flash_points ->
        incr_points = Enum.flat_map(flash_points, fn pt -> neighbors(map, pt, acc) end)

        for pt <- incr_points, reduce: map do
          map -> Map.update!(map, pt, &(&1 + 1))
        end
        |> resolve_flashes(flash_points ++ acc)
    end
  end

  @spec neighbors(any, {integer, any}, any) :: list
  def neighbors(map, {r, c}, ignore \\ []) do
    for nr <- (r - 1)..(r + 1),
        nc <- (c - 1)..(c + 1),
        {nr, nc} != {r, c},
        {nr, nc} not in ignore,
        Map.has_key?(map, {nr, nc}) do
      {nr, nc}
    end
  end
end
