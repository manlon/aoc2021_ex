defmodule Aoc2021Ex.Day22 do
  use Aoc2021Ex.Day

  def solve1 do
    for {onoff, [{minx, maxx}, {miny, maxy}, {minz, maxz}]} <- parsed_input(), reduce: %{} do
      map ->
        IO.inspect({onoff, {minx, maxx}, {miny, maxy}, {minz, maxz}})

        for x <- minx..maxx,
            x in -50..50,
            y <- miny..maxy,
            y in -50..50,
            z <- minz..maxz,
            z in -50..50,
            reduce: map do
          map ->
            Map.put(map, {x, y, z}, onoff)
        end
    end
    |> Map.values()
    |> Enum.sum()
  end

  def solve2 do
    parsed_input()
    |> Enum.reverse()
    |> Enum.reduce({[], []}, fn {onoff, region}, {offs, ons} ->
      case onoff do
        # on
        1 ->
          new_ons =
            subtract_all([region], ons ++ offs)
            |> subtract_all(ons)

          {offs, new_ons ++ ons}

        # off
        0 ->
          new_offs = subtract_all([region], ons ++ offs)

          {new_offs ++ offs, ons}
      end
    end)
  end

  def region_overlap([xs1, ys1, zs1], [xs2, ys2, zs2]) do
    case coord_overlap(xs1, xs2) do
      nil ->
        nil

      xs ->
        case coord_overlap(ys1, ys2) do
          nil ->
            nil

          ys ->
            case coord_overlap(zs1, zs2) do
              nil ->
                nil

              zs ->
                [xs, ys, zs]
            end
        end
    end
  end

  def coord_overlap({min1, max1}, {min2, max2}) do
    min = Enum.max([min1, min2])
    max = Enum.min([max1, max2])

    if min > max do
      nil
    else
      {min, max}
    end
  end

  def subtract_all(regions, []), do: regions

  def subtract_all(regions, [subtracted | rest]) do
    Enum.flat_map(regions, fn r -> subtract(r, subtracted) end)
    |> subtract_all(rest)
  end

  def subtract(keep = [{kxmin, kxmax}, {kymin, kymax}, {kzmin, kzmax}], remove) do
    case region_overlap(keep, remove) do
      nil ->
        [keep]

      [{oxmin, oxmax}, {oymin, oymax}, {ozmin, ozmax}] = o ->
        for xs = {xmin, xmax} <- [{kxmin, oxmin - 1}, {oxmin, oxmax}, {oxmax + 1, kxmax}],
            xmin <= xmax,
            ys = {ymin, ymax} <- [{kymin, oymin - 1}, {oymin, oymax}, {oymax + 1, kymax}],
            ymin <= ymax,
            zs = {zmin, zmax} <- [{kzmin, ozmin - 1}, {ozmin, ozmax}, {ozmax + 1, kzmax}],
            zmin <= zmax,
            [xs, ys, zs] != o do
          [xs, ys, zs]
        end
    end
  end

  def region_size([{x1, x2}, {y1, y2}, {z1, z2}]) do
    (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)
  end

  def parsed_input do
    for line <- input_lines(),
        [onoff, coords] = String.split(line, " "),
        coords = String.split(coords, ","),
        coords = Enum.map(coords, &parse_coord/1) do
      onoff = if onoff == "on", do: 1, else: 0
      {onoff, coords}
    end
  end

  def parse_coord(coord) do
    [_, range] = String.split(coord, "=")

    [min, max] =
      String.split(range, "..")
      |> Enum.map(&String.to_integer/1)

    {min, max}
  end
end
