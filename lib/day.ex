defmodule Aoc2021Ex.Day do
  defmacro __using__(_opts) do
    mod =
      __CALLER__.module
      |> Atom.to_string()
      |> String.split(".")
      |> List.last()

    if String.starts_with?(mod, "Day") do
      daynum =
        mod
        |> String.replace_prefix("Day", "")
        |> String.to_integer()

      modules =
        for i <- 1..daynum//1 do
          num =
            Integer.to_string(i)
            |> String.pad_leading(2, "0")

          Module.concat(Aoc2021Ex, "Day#{num}")
        end

      module_num = String.pad_leading(Integer.to_string(daynum), 2, "0")

      for mod <- modules do
        quote do
          alias unquote(mod)
        end
      end ++
        [
          quote do
            def input_file do
              "input/input#{unquote(module_num)}.txt"
            end

            def input do
              File.read!(input_file())
              |> String.trim()
            end

            def input_lines do
              input()
              |> String.split("\n")
            end

            def input_ints do
              input_lines()
              |> Enum.map(&String.to_integer/1)
            end

            def input_tokens do
              input_lines()
              |> Enum.map(&String.split/1)
            end
          end
        ]
    end
  end
end
