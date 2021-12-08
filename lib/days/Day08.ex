defmodule Aoc2021Ex.Day08 do
  use Aoc2021Ex.Day

  @segments %{
    0 => [:a, :b, :c, :e, :f, :g],
    1 => [:c, :f],
    2 => [:a, :c, :d, :e, :g],
    3 => [:a, :c, :d, :f, :g],
    4 => [:b, :c, :d, :f],
    5 => [:a, :b, :d, :f, :g],
    6 => [:a, :b, :d, :e, :f, :g],
    7 => [:a, :c, :f],
    8 => [:a, :b, :c, :d, :e, :f, :g],
    9 => [:a, :b, :c, :d, :f, :g]
  }
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

  def solve_segment_map(digit_clusters) do
    [cf, bcdf, acf, abcdefg] =
      [1, 4, 7, 8]
      |> Enum.map(fn d ->
        Enum.find(digit_clusters, fn c -> length(c) == @seg_counts_uniq[d] end)
      end)

    a = acf -- cf
    two_three_five = Enum.filter(digit_clusters, fn c -> length(c) == 5 end)
    dg = intersect(two_three_five) -- a
    g = dg -- bcdf
    d = dg -- g
    b = bcdf -- (cf ++ d)
    e = abcdefg -- (acf ++ b ++ d ++ g)
    three_six_nine = Enum.filter(digit_clusters, fn c -> length(c) == 6 end)

    f =
      Enum.map(three_six_nine, fn segs -> segs -- (a ++ b ++ d ++ e ++ g) end)
      |> Enum.find(fn x -> length(x) == 1 end)

    c = cf -- f

    map = %{a: hd(a), b: hd(b), c: hd(c), d: hd(d), e: hd(e), f: hd(f), g: hd(g)}

    Enum.map(@segments, fn {digit, digit_segs} ->
      {Enum.sort(Enum.map(digit_segs, fn seg -> Map.get(map, seg) end)), digit}
    end)
    |> Map.new()
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

  def intersect([list]), do: list

  def intersect([l1, l2 | rest]) do
    filtered = for i <- l1, i in l2, do: i
    intersect([filtered | rest])
  end
end
