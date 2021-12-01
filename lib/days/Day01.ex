defmodule Aoc2021Ex.Day01 do
  use Aoc2021Ex.Importer

  @input "input/input01.txt"

  def solve do
    {solve1(), solve2()}
  end

  def solve1 do
    num_increases(input(), 0)
  end

  def solve2 do
    input()
    |> Enum.chunk_every(3, 1)
    |> Enum.map(&Enum.sum/1)
    |> num_increases(0)
  end

  def input do
    File.read!(@input)
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def num_increases([_], acc) do
    acc
  end

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
