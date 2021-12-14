defmodule Aoc2021Ex.Day14 do
  use Aoc2021Ex.Day

  def solve1, do: min_max_diff(10)
  def solve2, do: min_max_diff(40)

  def min_max_diff(num_rounds) do
    {pattern, map} = parsed_input()
    pair_counts = count_pairs(pattern)
    edges = [Enum.at(pattern, 0), Enum.at(pattern, -1)]

    counts =
      expand_pairs(pair_counts, map, num_rounds)
      |> pair_counts_to_letter_counts(edges)
      |> Map.values()

    Enum.max(counts) - Enum.min(counts)
  end

  def expand_pairs(pair_counts, _, 0), do: pair_counts

  def expand_pairs(pair_counts, map, n) do
    Enum.reduce(pair_counts, %{}, fn {pair = {a, b}, count}, new_pairs ->
      insertion = map[pair]

      Map.update(new_pairs, {a, insertion}, count, &(&1 + count))
      |> Map.update({insertion, b}, count, &(&1 + count))
    end)
    |> expand_pairs(map, n - 1)
  end

  def count_pairs(run) do
    for([a, b] <- Enum.chunk_every(run, 2, 1, :discard), do: {a, b})
    |> Enum.frequencies()
  end

  def pair_counts_to_letter_counts(pair_counts, edges) do
    init = Enum.reduce(edges, %{}, fn e, map -> Map.update(map, e, 1, &(&1 + 1)) end)

    Enum.reduce(pair_counts, init, fn {{a, b}, count}, map ->
      Map.update(map, a, count, &(&1 + count))
      |> Map.update(b, count, &(&1 + count))
    end)
    |> Map.map(fn {_, x} -> div(x, 2) end)
  end

  def parsed_input do
    [pattern, rules] = String.split(input(), "\n\n")
    pattern = String.graphemes(pattern)

    map =
      for line <- String.split(rules, "\n"),
          [from, to] = String.split(line, " -> "),
          [f1, f2] = String.graphemes(from),
          into: %{} do
        {{f1, f2}, to}
      end

    {pattern, map}
  end
end
