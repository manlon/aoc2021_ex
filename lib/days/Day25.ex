defmodule Aoc2021Ex.Day25 do
  use Aoc2021Ex.Day

  @east ">"
  @south "v"

  def solve1 do
    map = input_map()
    {maxx, maxy} = Enum.max(Map.keys(map))
    step_until_stop(map, {maxx, maxy})
  end

  def solve2 do
    :ok
  end

  def step_until_stop(map, {maxx, maxy}, n \\ 0) do
    n = n + 1
    newmap = step(map, {maxx, maxy})

    if newmap == map do
      n
    else
      step_until_stop(newmap, {maxx, maxy}, n)
    end
  end

  def step(map, {maxx, maxy}) do
    map
    |> step_right({maxx, maxy})
    |> step_down({maxx, maxy})
  end

  def step_right(map, {maxx, _maxy}) do
    for {{x, y}, cuke} <- map,
        cuke == @east,
        reduce: map do
      newmap ->
        nextx = rem(x + 1, maxx + 1)

        if Map.has_key?(map, {nextx, y}) do
          newmap
        else
          newmap
          |> Map.delete({x, y})
          |> Map.put({nextx, y}, cuke)
        end
    end
  end

  def step_down(map, {_maxx, maxy}) do
    for {{x, y}, cuke} <- map,
        cuke == @south,
        reduce: map do
      newmap ->
        nexty = rem(y + 1, maxy + 1)

        if Map.has_key?(map, {x, nexty}) do
          newmap
        else
          newmap
          |> Map.delete({x, y})
          |> Map.put({x, nexty}, cuke)
        end
    end
  end

  def input_map do
    for {line, y} <- Enum.with_index(input_lines()),
        {c, x} <- Enum.with_index(String.graphemes(line)),
        reduce: %{} do
      map ->
        if c == "." do
          map
        else
          Map.put(map, {x, y}, c)
        end
    end
  end
end
