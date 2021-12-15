defmodule Aoc2021Ex.Day15 do
  use Aoc2021Ex.Day

  def solve1 do
    map = input_int_map()
    end_pos = Enum.max(Map.keys(map))
    Map.get(compute_best_paths(map), end_pos)
  end

  def solve2 do
    map = tile(input_int_map(), 5)
    end_pos = Enum.max(Map.keys(map))
    Map.get(compute_best_paths(map), end_pos)
  end

  def compute_best_paths(map), do: compute_best_paths(map, %{}, [{{0, 0}, 0}])
  def compute_best_paths(_, best_paths, []), do: best_paths

  def compute_best_paths(map, best_paths, to_add) do
    {best_paths, added} =
      for {pos, score} <- to_add, reduce: {best_paths, []} do
        {best_paths = %{^pos => v}, added} when score >= v ->
          {best_paths, added}

        {best_paths, added} ->
          {Map.put(best_paths, pos, score), [pos | added]}
      end

    to_add =
      Enum.flat_map(added, fn pos ->
        for n <- neighbors(pos, map) do
          {n, Map.get(best_paths, pos) + Map.get(map, n)}
        end
      end)

    compute_best_paths(map, best_paths, to_add)
  end

  def neighbors({x, y}, map, ignore \\ []) do
    for pos <- [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}],
        pos != {x, y},
        Map.has_key?(map, pos),
        pos not in ignore do
      pos
    end
  end

  def tile(map, n) do
    {maxx, maxy} = Enum.max(Map.keys(map))
    {dimx, dimy} = {maxx + 1, maxy + 1}

    for tx <- 0..(n - 1),
        ty <- 0..(n - 1),
        incr = tx + ty,
        dx = tx * dimx,
        dy = ty * dimy,
        reduce: %{} do
      result ->
        for {{x, y}, val} <- map, reduce: result do
          result ->
            new_val =
              if val + incr > 9 do
                val + incr - 9
              else
                val + incr
              end

            new_pos = {x + dx, y + dy}
            Map.put(result, new_pos, new_val)
        end
    end
  end
end
