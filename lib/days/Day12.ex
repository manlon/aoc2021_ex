defmodule Aoc2021Ex.Day12 do
  use Aoc2021Ex.Day
  @start_path [{{:small, "start"}, MapSet.new(), false}]
  @end_cave {:small, "end"}
  def solve1, do: count_paths(parsed_input(), false)
  def solve2, do: count_paths(parsed_input(), true)

  def count_paths(map, can_repeat?, paths \\ @start_path, acc \\ 0)
  def count_paths(_, _, [], acc), do: acc

  def count_paths(map, can_repeat?, _paths = [path = {cur, visits, repeated?} | rest], acc) do
    {acc, paths} =
      for pos <- Map.get(map, cur), can_visit?(pos, path, can_repeat?), reduce: {acc, rest} do
        {acc, paths} ->
          if pos == @end_cave do
            {acc + 1, paths}
          else
            new_path =
              {pos, MapSet.put(visits, pos), repeated? || (is_small?(pos) && pos in visits)}

            {acc, [new_path | paths]}
          end
      end

    count_paths(map, can_repeat?, paths, acc)
  end

  def is_small?({size, _}), do: size == :small
  def can_visit?({:big, _}, _, _), do: true
  def can_visit?({:small, _}, {_, _, false}, true), do: true
  def can_visit?(pos, {_, visited, _}, _), do: !MapSet.member?(visited, pos)

  def parsed_input do
    input_lines()
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, fn [a, b], map ->
      for {x, y} <- [{a, b}, {b, a}], x != "end", y != "start", reduce: map do
        map ->
          {source, dest} = {case_pair(x), case_pair(y)}
          Map.update(map, source, [dest], &[dest | &1])
      end
    end)
  end

  def case_pair(s), do: if(String.downcase(s) == s, do: {:small, s}, else: {:big, s})
end
