defmodule Aoc2021Ex.Day06 do
  use Aoc2021Ex.Day

  def solve1, do: tick(initial_fish(), 80)
  def solve2, do: tick(initial_fish(), 256)

  def tick(fish, 0), do: Enum.sum(fish)

  def tick([breeders, t0, t1, t2, t3, t4, t5, t6, t7], n) do
    tick([t0, t1, t2, t3, t4, t5, t6 + breeders, t7, breeders], n - 1)
  end

  def initial_fish do
    map = Enum.frequencies(input_comma_ints())
    Enum.map(0..8, fn i -> Map.get(map, i, 0) end)
  end
end
