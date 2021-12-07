defmodule Aoc2021Ex.Day07 do
  use Aoc2021Ex.Day
  def solve1, do: best_moves(input_comma_ints(), &linear_moves/2)
  def solve2, do: best_moves(input_comma_ints(), &triangle_moves/2)

  def best_moves(positions, move_func) do
    {min, max} = {Enum.min(positions), Enum.max(positions)}
    best = Enum.min_by(min..max, fn d -> Enum.sum(move_func.(positions, d)) end)
    move_func.(positions, best) |> Enum.sum()
  end

  def linear_moves(positions, target) do
    Enum.map(positions, fn x -> abs(target - x) end)
  end

  def triangle_moves(positions, target) do
    Enum.map(positions, fn x ->
      d = abs(target - x)
      div(d * d + d, 2)
    end)
  end
end
