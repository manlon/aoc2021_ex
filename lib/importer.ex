defmodule Aoc2021Ex.Importer do
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

      for mod <- modules do
        quote do
          alias unquote(mod)
        end
      end
    end
  end
end
