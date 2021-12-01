defmodule Aoc2021Ex.Day01 do
  use Aoc2021Ex.Day

  def solve do
    {solve1(), solve2()}
  end

  def solve1 do
    num_increases(input_ints())
  end

  def solve2 do
    input_ints()
    |> Enum.chunk_every(3, 1)
    |> Enum.map(&Enum.sum/1)
    |> num_increases()
  end

  def num_increases(list, acc \\ 0)
  def num_increases([_], acc), do: acc

  def num_increases([a, b | rest], acc) do
    acc =
      if b > a do
        acc + 1
      else
        acc
      end

    num_increases([b | rest], acc)
  end
end
