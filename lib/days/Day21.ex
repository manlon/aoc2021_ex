defmodule Aoc2021Ex.Day21 do
  use Aoc2021Ex.Day
  @p1_start 8
  @p2_start 3

  def solve1 do
    [{@p1_start, 0}, {@p2_start, 0}]
    |> play(1, 0)
    |> then(fn {x, y} -> x * y end)
  end

  def solve2 do
    [{@p1_start, 0}, {@p2_start, 0}]
    |> play_dirac(1, {0, 0})
    |> then(fn {a, b} -> Enum.max([a, b]) end)
  end

  def play([{space, score}, {_, other_score} = p2], next_roll, n) do
    move =
      for i <- 0..2 do
        norm(next_roll + i, 100)
      end
      |> Enum.sum()

    space = norm(space + move, 10)
    score = score + space
    next_roll = norm(next_roll + 3, 100)
    n = n + 3

    if score >= 1000 do
      {other_score, n}
    else
      play([p2, {space, score}], next_roll, n)
    end
  end

  @dirac_freqs %{3 => 1, 4 => 3, 5 => 6, 6 => 7, 7 => 6, 8 => 3, 9 => 1}
  def play_dirac([{space1, score1}, {space2, score2}], worlds, {wins1, wins2}) do
    for {move, num_worlds} <- @dirac_freqs, reduce: {wins1, wins2} do
      {wins1, wins2} ->
        newspace = norm(space1 + move, 10)
        newscore = score1 + newspace

        if newscore >= 21 do
          {wins1 + worlds * num_worlds, wins2}
        else
          {wins2, wins1} =
            play_dirac(
              [{space2, score2}, {newspace, newscore}],
              worlds * num_worlds,
              {wins2, wins1}
            )

          {wins1, wins2}
        end
    end
  end

  def norm(n, max), do: if(n <= max, do: n, else: norm(n - max, max))
end
