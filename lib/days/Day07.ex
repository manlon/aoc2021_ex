defmodule Aoc2021Ex.Day07 do
  use Aoc2021Ex.Day
  def solve1, do: best_moves(input_comma_ints(), &linear_move_sum/2)
  def solve2, do: best_moves(input_comma_ints(), &triangle_move_sum/2)

  def best_moves(positions, move_func) do
    {min, max} = {Enum.min(positions), Enum.max(positions)}
    Enum.min(Enum.map(min..max, fn x -> move_func.(positions, x) end))
  end

  def linear_move_sum(positions, target) do
    Enum.map(positions, fn x -> abs(target - x) end) |> Enum.sum()
  end

  def triangle_move_sum(positions, target) do
    Enum.map(positions, fn x ->
      d = abs(target - x)
      div(d * d + d, 2)
    end)
    |> Enum.sum()
  end
end
