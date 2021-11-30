defmodule Aoc2021Ex do
  @moduledoc """
  Documentation for `Aoc2021Ex`.
  """

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
