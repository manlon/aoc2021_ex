defmodule Aoc2021Ex.Day13 do
  use Aoc2021Ex.Day

  def solve1 do
    {map, [instr | _]} = parsed_input()
    MapSet.size(fold(instr, map))
  end

  def solve2 do
    {map, folds} = parsed_input()
    result = map_to_str(Enum.reduce(folds, map, &fold/2))
    IO.puts(result)
    result
  end

  def fold({:x, loc}, map) do
    for {x, y} <- map, into: MapSet.new() do
      if x > loc do
        {loc - (x - loc), y}
      else
        {x, y}
      end
    end
  end

  def fold({:y, loc}, map) do
    for {x, y} <- map, into: MapSet.new() do
      if y > loc do
        {x, loc - (y - loc)}
      else
        {x, y}
      end
    end
  end

  def map_to_str(map) do
    {maxx, maxy} =
      for {x, y} <- map, reduce: {0, 0} do
        {maxx, maxy} ->
          {Enum.max([x, maxx]), Enum.max([y, maxy])}
      end

    for y <- 0..maxy do
      for x <- 0..maxx, into: "" do
        if MapSet.member?(map, {x, y}) do
          "#"
        else
          " "
        end
      end
    end
    |> Enum.join("\n")
  end

  def parsed_input do
    [point_locs, fold_instrs] = String.split(input(), "\n\n")

    points =
      for line <- String.split(point_locs, "\n"),
          coords = String.split(line, ","),
          [x, y] = Enum.map(coords, &String.to_integer/1),
          into: MapSet.new() do
        {x, y}
      end

    folds =
      for line <- String.split(fold_instrs, "\n"),
          instr = Enum.at(String.split(line, " "), 2),
          [axis, loc] = String.split(instr, "=") do
        {String.to_atom(axis), String.to_integer(loc)}
      end

    {points, folds}
  end
end
