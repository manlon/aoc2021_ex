defmodule Aoc2021Ex.Day08 do
  use Aoc2021Ex.Day
  @seg_counts_uniq %{1 => 2, 4 => 4, 7 => 3, 8 => 7}

  def solve1 do
    Enum.reduce(parsed_input(), 0, fn {_, digits}, acc ->
      Enum.count(digits, &(length(&1) in Map.values(@seg_counts_uniq))) + acc
    end)
  end

  def solve2 do
    Enum.reduce(parsed_input(), 0, fn {digits, result}, acc ->
      soln = solve_segment_map(digits)
      Integer.undigits(Enum.map(result, &soln[&1])) + acc
    end)
  end

  def solve_segment_map(digits) do
    {[d1], digits} = Enum.split_with(digits, &(length(&1) == @seg_counts_uniq[1]))
    {[d4], digits} = Enum.split_with(digits, &(length(&1) == @seg_counts_uniq[4]))
    {[d7], digits} = Enum.split_with(digits, &(length(&1) == @seg_counts_uniq[7]))
    {[d8], digits} = Enum.split_with(digits, &(length(&1) == @seg_counts_uniq[8]))
    {two_three_five, zero_six_nine} = Enum.split_with(digits, &(length(&1) == 5))
    {[d3], two_five} = Enum.split_with(two_three_five, &(d1 -- &1 == []))
    {zero_nine, [d6]} = Enum.split_with(zero_six_nine, &(d1 -- &1 == []))
    {[d5], [d2]} = Enum.split_with(two_five, &(&1 -- d6 == []))
    {[d9], [d0]} = Enum.split_with(zero_nine, &(&1 -- (d5 ++ d1) == []))

    %{d0 => 0, d1 => 1, d2 => 2, d3 => 3, d4 => 4, d5 => 5, d6 => 6, d7 => 7, d8 => 8, d9 => 9}
  end

  def parsed_input do
    Stream.map(input_lines(), &String.split(&1, " | "))
    |> Enum.map(fn [a, b] -> {parse_clusters(a), parse_clusters(b)} end)
  end

  def parse_clusters(clusters) do
    String.split(clusters)
    |> Enum.map(&Enum.sort(String.graphemes(&1)))
    |> Enum.map(fn c -> Enum.map(c, &String.to_atom/1) end)
  end
end
