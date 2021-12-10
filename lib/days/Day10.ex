defmodule Aoc2021Ex.Day10 do
  use Aoc2021Ex.Day

  @illegal_score %{?) => 3, ?] => 57, ?} => 1197, ?> => 25137}
  @compl_score %{?) => 1, ?] => 2, ?} => 3, ?> => 4}
  @flip %{?( => ?), ?[ => ?], ?{ => ?}, ?< => ?>}

  def solve1 do
    Enum.sum(for {:invalid, c} <- parsed_input(), do: @illegal_score[c])
  end

  def solve2 do
    scores = Enum.sort(for {:done, compl} <- parsed_input(), do: score_compl(compl, 0))
    Enum.at(scores, div(length(scores), 2))
  end

  def score_compl([], acc), do: acc
  def score_compl([char | rest], acc), do: score_compl(rest, acc * 5 + @compl_score[char])

  def parsed_input(), do: Enum.map(input_lines(), &parse/1)

  def parse(line, acc \\ [])
  def parse(<<c, rest::binary>>, acc) when c in '([{<', do: parse(rest, [@flip[c] | acc])
  def parse(<<c, rest::binary>>, [c | acc]), do: parse(rest, acc)
  def parse(<<c, _::binary>>, _), do: {:invalid, c}
  def parse("", acc), do: {:done, acc}
end
