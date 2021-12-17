defmodule Aoc2021Ex.Day17 do
  use Aoc2021Ex.Day

  # target area: x=94..151, y=-156..-103
  @target_x 94..151
  @target_y -156..-103
  @maxx 151
  @miny -156

  def solve1, do: Enum.max(for {_, maxy} <- valid_velocities(), do: maxy)
  def solve2, do: Enum.count(valid_velocities())

  def valid_velocities do
    for vx <- 1..151,
        vy <- -200..200,
        highest = hits?({vx, vy}),
        highest do
      {{vx, vy}, highest}
    end
  end

  def in_target?({x, y}), do: x in @target_x && y in @target_y
  def missed?({x, y}), do: x > @maxx || y < @miny

  def hits?({vx, vy} = _vel, {x, y} = pos \\ {0, 0}, max \\ -1000) do
    max = if y > max, do: y, else: max

    if in_target?(pos) do
      max
    else
      if missed?(pos) do
        false
      else
        new_vx = if vx > 0, do: vx - 1, else: vx
        hits?({new_vx, vy - 1}, {x + vx, y + vy}, max)
      end
    end
  end
end
