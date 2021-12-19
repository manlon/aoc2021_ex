defmodule Aoc2021Ex.Day19 do
  use Aoc2021Ex.Day

  def solve1 do
    {points, _} =
      parsed_input()
      |> Map.values()
      |> collapse()

    Enum.count(points)
  end

  def solve2 do
    {_, origins} =
      parsed_input()
      |> Map.values()
      |> collapse()

    max_manhattan([{0, 0, 0} | origins])
  end

  def collapse([first | rest]), do: collapse(first, rest, [], [])
  def collapse(into, [], [], acc), do: {into, acc}
  def collapse(into, [], tried, acc), do: collapse(into, Enum.reverse(tried), [], acc)

  def collapse(into, [set | rest], tried, acc) do
    IO.inspect(l: length(rest) , t: length(tried), x: length(rest) + length(tried))

    case detect_overlap(into, set) do
      nil ->
        collapse(into, rest, [set | tried], acc)

      {_, collapsed, dist} ->
        collapse(collapsed, rest, tried, [dist | acc])
    end
  end

  def equiv({x, y, z}) do
    [{x, y, z}, {-y, x, z}, {-x, -y, z}, {y, -x, z}, {-z, y, x}, {z, y, -x}]
    |> Enum.flat_map(fn {x, y, z} -> [{x, y, z}, {x, z, -y}, {x, -y, -z}, {x, -z, y}] end)
  end

  def rot_funs() do
    [
      &{&1, &2, &3},
      &{-&2, &1, &3},
      &{-&1, -&2, &3},
      &{&2, -&1, &3},
      &{-&3, &2, &1},
      &{&3, &2, -&1}
    ]
    |> Enum.flat_map(fn func ->
      [&func.(&1, &2, &3), &func.(&1, &3, -&2), &func.(&1, -&2, -&3), &func.(&1, -&3, &2)]
    end)
    |> Enum.map(fn func -> fn {x, y, z} -> func.(x, y, z) end end)
  end

  @spec parsed_input :: map
  def parsed_input do
    input()
    |> String.split("\n\n")
    |> Enum.map(&parse_scanner/1)
    |> Map.new()
  end

  def manhattan({x1, y1, z1}, {x2, y2, z2}) do
    abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
  end

  def max_manhattan(points) do
    for a <- points,
        b <- points do
      manhattan(a, b)
    end
    |> Enum.max()
  end

  def parse_scanner(scanner) do
    [scanner | points] = String.split(scanner, "\n")

    scanner =
      String.split(scanner)
      |> Enum.at(2)
      |> String.to_integer()

    points =
      for line <- points,
          coords = String.split(line, ","),
          [x, y, z] = Enum.map(coords, &String.to_integer/1) do
        {x, y, z}
      end

    {scanner, points}
  end

  def detect_overlap(pointsa, pointsb) do
    Enum.reduce_while(pointsa, nil, fn a, acc ->
      Enum.reduce_while(pointsb, acc, fn b, acc ->
        {xa, ya, za} = a
        {xb, yb, zb} = b
        {dx, dy, dz} = {xa - xb, ya - yb, za - zb}

        bdiffs =
          for {x, y, z} <- pointsb do
            {x - xb, y - yb, z - zb}
          end

        rotated_b_sets =
          Enum.map(bdiffs, &equiv/1)
          |> Enum.zip()
          |> Enum.map(&Tuple.to_list/1)
          |> Enum.map(fn diffs ->
            for {ddx, ddy, ddz} <- diffs do
              {xb + dx + ddx, yb + dy + ddy, zb + dz + ddz}
            end
          end)

        rotated_origin =
          equiv({-xb, -yb, -zb})
          |> Enum.map(fn {ox, oy, oz} -> {xb + ox + dx, yb + oy + dy, zb + oz + dz} end)

        Enum.zip(rotated_b_sets, rotated_origin)
        |> Enum.reduce_while(acc, fn {rotation, origin}, _ ->
          dups = overlaps(pointsa, rotation)

          if length(dups) >= 12 do
            {:halt, {dups, Enum.uniq(pointsa ++ rotation), origin}}
          else
            {:cont, nil}
          end
        end)
        |> wrap_reduce()
      end)
      |> wrap_reduce()
    end)
  end

  def wrap_reduce(result) do
    case result do
      nil ->
        {:cont, nil}

      result ->
        {:halt, result}
    end
  end

  def overlaps(set1, set2) do
    for x <- set1, x in set2, do: x
  end
end
