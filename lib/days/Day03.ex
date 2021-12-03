defmodule Aoc2021Ex.Day03 do
  use Aoc2021Ex.Day

  def solve do
    {solve1(), solve2()}
  end

  def solve1 do
    lines = input_lines()
    size = hd(lines) |> String.length()

    gamma =
      Enum.join(Enum.map(0..(size - 1), &most_common_digit_at(lines, &1)))
      |> String.to_integer(2)

    gamma * (Integer.pow(2, size) - 1 - gamma)
  end

  def solve2 do
    lines = input_lines()
    oxy = filter_nums(lines, 0, &Kernel.>=/2)
    co2 = filter_nums(lines, 0, &Kernel.</2)
    oxy * co2
  end

  def most_common_digit_at(strings, idx) do
    zeroes = Enum.count(strings, fn s -> String.at(s, idx) == "0" end)
    if zeroes > div(length(strings), 2), do: "0", else: "1"
  end

  def filter_nums([result], _, _), do: String.to_integer(result, 2)

  def filter_nums(candidates, idx, length_choice) do
    grouped = Enum.group_by(candidates, &String.at(&1, idx))
    ones = grouped["1"]
    zeroes = grouped["0"]

    rest =
      if length_choice.(length(ones), length(zeroes)) do
        ones
      else
        zeroes
      end

    filter_nums(rest, idx + 1, length_choice)
  end
end
