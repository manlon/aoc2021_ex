defmodule Aoc2021Ex do
  @moduledoc """
  Documentation for `Aoc2021Ex`.
  """
  use Aoc2021Ex.Day

  def solve_all do
    [
      Aoc2021Ex.Day01,
      Aoc2021Ex.Day02,
      Aoc2021Ex.Day03,
      Aoc2021Ex.Day04,
      Aoc2021Ex.Day05,
      Aoc2021Ex.Day06,
      Aoc2021Ex.Day07,
      Aoc2021Ex.Day08,
      Aoc2021Ex.Day09,
      Aoc2021Ex.Day10,
      Aoc2021Ex.Day11,
      Aoc2021Ex.Day12,
      Aoc2021Ex.Day13,
      Aoc2021Ex.Day14,
      Aoc2021Ex.Day15,
      Aoc2021Ex.Day16,
      Aoc2021Ex.Day17,
      Aoc2021Ex.Day18,
      #Aoc2021Ex.Day19,
      #Aoc2021Ex.Day20,
      #Aoc2021Ex.Day21,
      #Aoc2021Ex.Day22,
      #Aoc2021Ex.Day23,
      #Aoc2021Ex.Day24,
      #Aoc2021Ex.Day25
    ]
    |> Enum.with_index()
    |> Enum.map(fn {mod, i} ->
      {time, res} = :timer.tc(fn -> apply(mod, :solve, []) end)
      IO.inspect(day: i, result: res, time: time)
    end)
    :ok
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
