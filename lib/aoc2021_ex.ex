defmodule Aoc2021Ex do
  @moduledoc """
  Documentation for `Aoc2021Ex`.
  """
  use Aoc2021Ex.Day

  def solve_all do
    [
      Aoc2021Ex.Day01.solve,
      Aoc2021Ex.Day02.solve,
      Aoc2021Ex.Day03.solve,
      Aoc2021Ex.Day04.solve,
      Aoc2021Ex.Day05.solve,
      Aoc2021Ex.Day06.solve,
      Aoc2021Ex.Day07.solve,
      Aoc2021Ex.Day08.solve,
      Aoc2021Ex.Day09.solve,
      Aoc2021Ex.Day10.solve,
      Aoc2021Ex.Day11.solve,
      Aoc2021Ex.Day12.solve,
      Aoc2021Ex.Day13.solve,
      Aoc2021Ex.Day14.solve,
      Aoc2021Ex.Day15.solve,
      Aoc2021Ex.Day16.solve,
      Aoc2021Ex.Day17.solve,
      Aoc2021Ex.Day18.solve,
    ]
  end

  def make_module(day) do
    num = String.pad_leading(Integer.to_string(day), 2, "0")
    mod_name = "Day#{num}"
    file = "lib/days/#{mod_name}.ex"

    if File.exists?(file) do
      raise "file #{file} already exists"
    else
      src =
        File.read!("lib/days/template.ex")
        |> String.replace("Template", mod_name)

      File.write!(file, src)
      Code.compile_file(file)
    end
  end

  defmacro reload! do
    IEx.Helpers.recompile()

    for i <- 1..25 do
      num = String.pad_leading(Integer.to_string(i), 2, "0")
      mod = Module.concat(Aoc2021Ex, "Day#{num}")

      quote do
        alias unquote(mod)
      end
    end
  end
end
