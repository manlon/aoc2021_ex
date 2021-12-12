defmodule Aoc2021Ex.Day12 do
  use Aoc2021Ex.Day

  @start_path [{[{:small, "start"}], false}]
  def solve1 do
    expand(parsed_input(), @start_path, false, [])
    |> length()
  end

  def solve2 do
    expand(parsed_input(), @start_path, true, [])
    |> length()
  end

  def parsed_input do
    input_lines()
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, fn [a, b], map ->
      for {x, y} <- [{a, b}, {b, a}], x != "end", y != "start", reduce: map do
        map ->
          source = case_pair(x)
          dest = case_pair(y)
          Map.update(map, source, [dest], &[dest | &1])
      end
    end)
  end

  def expand(_, [], _, acc), do: acc

  def expand(
        transitions,
        _paths = [path = {path_positions = [pos | _], has_double?} | rest],
        allow_double?,
        acc
      ) do
    next_positions =
      Map.get(transitions, pos)
      |> Enum.filter(fn next_pos -> can_visit?(next_pos, path, allow_double?) end)

    {terminals, new_paths} =
      Enum.map(next_positions, fn next_pos ->
        {[next_pos | path_positions],
         has_double? || (is_small?(next_pos) && next_pos in path_positions)}
      end)
      |> Enum.split_with(fn {[last_pos | _], _} -> last_pos == {:small, "end"} end)

    expand(transitions, rest ++ new_paths, allow_double?, terminals ++ acc)
  end

  def is_small?({size, _}), do: size == :small
  def can_visit?({:big, _}, _, _), do: true
  def can_visit?({:small, _}, {_, false}, true), do: true
  def can_visit?(pos, {path, _}, _), do: pos not in path

  def case_pair(s) do
    if String.downcase(s) == s do
      {:small, s}
    else
      {:big, s}
    end
  end
end
