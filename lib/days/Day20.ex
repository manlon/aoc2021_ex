defmodule Aoc2021Ex.Day20 do
  use Aoc2021Ex.Day

  def solve1, do: apply_n(2)
  def solve2, do: apply_n(50)
  def apply_n(n), do: Enum.sum(Map.values(apply_alg(parsed_input(), n, 0)))

  def apply_alg({_alg, map}, 0, _default_pixel), do: map

  def apply_alg({alg, map}, n, default_pixel) do
    {{minx, miny}, {maxx, maxy}} = corners(map)

    newmap =
      for x <- (minx - 1)..(maxx + 1),
          y <- (miny - 1)..(maxy + 1),
          reduce: %{} do
        newmap ->
          num =
            for ny <- (y - 1)..(y + 1),
                nx <- (x - 1)..(x + 1) do
              Map.get(map, {nx, ny}, default_pixel)
            end
            |> Integer.undigits(2)

          replacement = Enum.at(alg, num)
          Map.put(newmap, {x, y}, replacement)
      end

    apply_alg({alg, newmap}, n - 1, if(default_pixel == 0, do: 1, else: 0))
  end

  def corners(map) do
    {xs, ys} =
      for {x, y} <- Map.keys(map), reduce: {[], []} do
        {xs, ys} ->
          {[x | xs], [y | ys]}
      end

    {minx, maxx} = minmax(xs)
    {miny, maxy} = minmax(ys)
    {{minx, miny}, {maxx, maxy}}
  end

  def minmax([first | list]) do
    Enum.reduce(list, {first, first}, fn item, {min, max} ->
      min = if item < min, do: item, else: min
      max = if item > max, do: item, else: max
      {min, max}
    end)
  end

  @pixels %{"." => 0, "#" => 1}
  def parsed_input do
    [alg, img] = String.split(input(), "\n\n")
    alg = for c <- String.graphemes(alg), do: @pixels[c]

    img =
      for {line, y} <- Enum.with_index(String.split(img, "\n")), reduce: %{} do
        map ->
          for {c, x} <- Enum.with_index(String.graphemes(line)), reduce: map do
            map ->
              Map.put(map, {x, y}, @pixels[c])
          end
      end

    {alg, img}
  end
end
