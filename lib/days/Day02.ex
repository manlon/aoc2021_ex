defmodule Aoc2021Ex.Day02 do
  use Aoc2021Ex.Day

  def solve1 do
    Enum.reduce(instructions(), {0, 0}, &move/2)
    |> then(fn {h, d} -> h * d end)
  end

  def solve2 do
    Enum.reduce(instructions(), {0, 0, 0}, &aim/2)
    |> then(fn {h, d, _} -> h * d end)
  end

  def instructions do
    input_tokens()
    |> Enum.map(fn [dir, n] -> {dir, String.to_integer(n)} end)
  end

  def move({"forward", x}, {h, d}), do: {h + x, d}
  def move({"up", x}, {h, d}), do: {h, d - x}
  def move({"down", x}, {h, d}), do: {h, d + x}

  def aim({"forward", x}, {h, d, a}), do: {h + x, d + a * x, a}
  def aim({"up", x}, {h, d, a}), do: {h, d, a - x}
  def aim({"down", x}, {h, d, a}), do: {h, d, a + x}
end
