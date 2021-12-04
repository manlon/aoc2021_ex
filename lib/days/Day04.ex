defmodule Aoc2021Ex.Day04 do
  use Aoc2021Ex.Day

  def solve do
    {solve1(), solve2()}
  end

  def solve1 do
    {nums, cards} = parse_input()

    {called, card} =
      Enum.reduce_while(nums, [], fn number, called ->
        called = [number | called]

        case Enum.find(cards, fn c -> win?(c, called) end) do
          nil ->
            {:cont, called}

          card ->
            {:halt, {called, card}}
        end
      end)

    score(called, card)
  end

  def solve2 do
    {nums, cards} = parse_input()

    {called, card} =
      Enum.reduce_while(nums, {cards, []}, fn number, {cards, called} ->
        called = [number | called]

        case cards do
          [card] ->
            if win?(card, called) do
              {:halt, {called, card}}
            else
              {:cont, {cards, called}}
            end

          _ ->
            cards = Enum.filter(cards, fn c -> !win?(c, called) end)
            {:cont, {cards, called}}
        end
      end)

    score(called, card)
  end

  def score(called = [num | _], card) do
    num *
      ((List.flatten(card) -- called)
       |> Enum.sum())
  end

  def parse_input do
    [number_input | cards_input] =
      input()
      |> String.split("\n\n")

    numbers =
      number_input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    cards =
      cards_input
      |> Enum.map(&parse_card/1)

    {numbers, cards}
  end

  def parse_card(cardstring) do
    String.split(cardstring, "\n")
    |> Enum.map(fn line -> Enum.map(String.split(line), &String.to_integer/1) end)
  end

  def win?(card, numbers) do
    Enum.any?(card, fn line -> Enum.all?(line, fn n -> n in numbers end) end) ||
      Enum.any?(invert_card(card), fn line -> Enum.all?(line, fn n -> n in numbers end) end)
  end

  def invert_card(card) do
    Enum.map(Enum.zip(card), &Tuple.to_list/1)
  end
end
