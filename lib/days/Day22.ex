defmodule Aoc2021Ex.Day22 do
  use Aoc2021Ex.Day

  def solve1 do
    target_region = [{-50, 50}, {-50, 50}, {-50, 50}]

    instructions =
      for {onoff, region} <- parsed_input(),
          overlap = region_overlap(target_region, region),
          overlap != nil do
        {onoff, overlap}
      end

    num_lights(instructions)
  end

  def solve2 do
    num_lights(parsed_input())
  end

  def num_lights(instructions) do
    Enum.reverse(instructions)
    |> Enum.reduce({[], []}, fn {onoff, region}, {ons, seen} ->
      case onoff do
        # on
        1 ->
          new_ons = subtract_all([region], seen)
          {new_ons ++ ons, [region | seen]}

        # off
        0 ->
          {ons, [region | seen]}
      end
    end)
    |> then(fn {ons, _} -> Enum.map(ons, &region_size/1) end)
    |> Enum.sum()
  end

  def region_overlap([xs1, ys1, zs1], [xs2, ys2, zs2]) do
    with {:ok, xs} <- coord_overlap(xs1, xs2),
         {:ok, ys} <- coord_overlap(ys1, ys2),
         {:ok, zs} <- coord_overlap(zs1, zs2) do
      [xs, ys, zs]
    end
  end

  def coord_overlap({min1, max1}, {min2, max2}) do
    min = Enum.max([min1, min2])
    max = Enum.min([max1, max2])

    if min > max do
      nil
    else
      {:ok, {min, max}}
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
