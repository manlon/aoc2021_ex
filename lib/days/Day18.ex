defmodule Aoc2021Ex.Day18 do
  use Aoc2021Ex.Day

  def solve1 do
    parse_input()
    |> Enum.reduce(fn num, acc ->
      add_nums(acc, num)
    end)
    |> magnitude()
  end

  def solve2 do
    nums = parse_input()
    for n1 <- nums,
        n2 <- nums do
      add_nums(n1, n2)
      |> magnitude()
    end
    |> Enum.max
  end

  def add_nums(tokens1, tokens2) do
    (["[" | tokens1] ++ tokens2 ++ ["]"])
    |> reduce()
  end

  def reduce(line) do
    case explode(line) do
      {false, _} ->
        case split(line) do
          {false, _} ->
            line

          {true, line} ->
            reduce(line)
        end

      {true, line} ->
        reduce(line)
    end
  end

  def add_to_first_int(list, int, lhs \\ [])
  def add_to_first_int([], _, lhs), do: Enum.reverse(lhs)

  def add_to_first_int([i | rest], int, lhs) when is_integer(i) do
    Enum.reverse(lhs) ++ [i + int | rest]
  end

  def add_to_first_int([x | rest], int, lhs) do
    add_to_first_int(rest, int, [x | lhs])
  end

  def explode(tokens, lhs \\ [], depth \\ 0)

  def explode(["[", a, b, "]" | rest], lhs, 4) when is_integer(a) and is_integer(b) do
    left = add_to_first_int(lhs, a)
    right = add_to_first_int(rest, b)
    {true, Enum.reverse(left) ++ [0 | right]}
  end

  def explode(["[" | rest], lhs, depth) do
    explode(rest, ["[" | lhs], depth + 1)
  end

  def explode(["]" | rest], lhs, depth) do
    explode(rest, ["]" | lhs], depth - 1)
  end

  def explode([a | rest], lhs, depth) when is_integer(a) do
    explode(rest, [a | lhs], depth)
  end

  def explode([], lhs, _) do
    {false, Enum.reverse(lhs)}
  end

  def split(toks, lhs \\ [])
  def split([], lhs), do: {false, Enum.reverse(lhs)}

  def split([i | rest], lhs) when is_integer(i) and i >= 10 do
    a = div(i, 2)
    b = i - a
    {true, Enum.reverse(lhs) ++ ["[", a, b, "]" | rest]}
  end

  def split([other | rest], lhs) do
    split(rest, [other | lhs])
  end

  def magnitude(list, lhs \\ [])
  def magnitude([x], _) when is_integer(x), do: x

  def magnitude(["[", a, b, "]" | rest], lhs) when is_integer(a) and is_integer(b) do
    mag = 3 * a + 2 * b
    magnitude(Enum.reverse(lhs) ++ [mag | rest])
  end

  def magnitude([x | rest], lhs), do: magnitude(rest, [x | lhs])

  def parse_input do
    for line <- input_lines() do
      parse_line(line)
    end
  end

  def parse_line(line) do
    for char <- String.graphemes(line),
        char != "," do
      case Integer.parse(char) do
        :error ->
          char

        {i, _} ->
          i
      end
    end
  end
end
