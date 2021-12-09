defmodule Aoc2021Ex.Day08 do
  use Aoc2021Ex.Day
  @seg_counts_uniq %{1 => 2, 4 => 4, 7 => 3, 8 => 7}

  def solve1 do
    parsed_input()
    |> Enum.map(fn {_, result_digits} ->
      Enum.count(result_digits, fn d -> length(d) in Map.values(@seg_counts_uniq) end)
    end)
    |> Enum.sum()
  end

  def solve2 do
    parsed_input()
    |> Enum.map(fn {digits, result} -> {solve_segment_map(digits), result} end)
    |> Enum.map(fn {map, result} -> Enum.map(result, fn d -> Map.get(map, d) end) end)
    |> Enum.map(&Integer.undigits/1)
    |> Enum.sum()
  end

  def solve_segment_map(digits) do
    {[d1], digits} = Enum.split_with(digits, fn d -> length(d) == @seg_counts_uniq[1] end)
    {[d4], digits} = Enum.split_with(digits, fn d -> length(d) == @seg_counts_uniq[4] end)
    {[d7], digits} = Enum.split_with(digits, fn d -> length(d) == @seg_counts_uniq[7] end)
    {[d8], digits} = Enum.split_with(digits, fn d -> length(d) == @seg_counts_uniq[8] end)
    {two_three_five, zero_six_nine} = Enum.split_with(digits, fn d -> length(d) == 5 end)
    {[d3], two_five} = Enum.split_with(two_three_five, fn d -> d1 -- d == [] end)
    {zero_nine, [d6]} = Enum.split_with(zero_six_nine, fn d -> d1 -- d == [] end)
    {[d5], [d2]} = Enum.split_with(two_five, fn d -> d -- d6 == [] end)
    {[d9], [d0]} = Enum.split_with(zero_nine, fn d -> d -- (d5 ++ d1) == [] end)

    %{d0 => 0, d1 => 1, d2 => 2, d3 => 3, d4 => 4, d5 => 5, d6 => 6, d7 => 7, d8 => 8, d9 => 9}
  end

  def parsed_input do
    input_lines()
    |> Enum.map(fn line -> String.split(line, " | ") end)
    |> Enum.map(fn pair -> List.to_tuple(Enum.map(pair, &parse_clusters/1)) end)
  end

  def parse_clusters(clusters) do
    clusters
    |> String.split()
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.sort/1)
    |> Enum.map(fn c -> Enum.map(c, &String.to_atom/1) end)
  end
end
