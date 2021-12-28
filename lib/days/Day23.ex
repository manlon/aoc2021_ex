defmodule Aoc2021Ex.Day23 do
  use Aoc2021Ex.Day

  @map %{
    r1: [:r2],
    r2: [:r1, :r3],
    r3: [:r2, :r4, :a1],
    r4: [:r3, :r5],
    r5: [:r4, :r6, :b1],
    r6: [:r5, :r7],
    r7: [:r6, :r8, :c1],
    r8: [:r7, :r9],
    r9: [:r8, :r10, :d1],
    r10: [:r9, :r11],
    r11: [:r10],
    a1: [:r3, :a2],
    a2: [:a1],
    b1: [:r5, :b2],
    b2: [:b1],
    c1: [:r7, :c2],
    c2: [:c1],
    d1: [:r9, :d2],
    d2: [:d1]
  }

  @blockers [:r3, :r5, :r7, :r9]
  @hallway [:r1, :r2, :r3, :r4, :r5, :r6, :r7, :r8, :r9, :r10, :r11]
  @destinations %{a: [:a1, :a2], b: [:b1, :b2], c: [:c1, :c2], d: [:d1, :d2]}
  @cost %{a: 1, b: 10, c: 100, d: 1000}

  @start [a1: :d, a2: :c, b1: :b, b2: :a, c1: :d, c2: :a, d1: :b, d2: :c]

  @map2 %{
    r1: [:r2],
    r2: [:r1, :r3],
    r3: [:r2, :r4, :a1],
    r4: [:r3, :r5],
    r5: [:r4, :r6, :b1],
    r6: [:r5, :r7],
    r7: [:r6, :r8, :c1],
    r8: [:r7, :r9],
    r9: [:r8, :r10, :d1],
    r10: [:r9, :r11],
    r11: [:r10],
    a1: [:r3, :a2],
    a2: [:a1, :a3],
    a3: [:a2, :a4],
    a4: [:a3],
    b1: [:r5, :b2],
    b2: [:b1, :b3],
    b3: [:b2, :b4],
    b4: [:b3],
    c1: [:r7, :c2],
    c2: [:c1, :c3],
    c3: [:c2, :c4],
    c4: [:c3],
    d1: [:r9, :d2],
    d2: [:d1, :d3],
    d3: [:d2, :d4],
    d4: [:d3]
  }
  @destinations2 %{
    a: [:a1, :a2, :a3, :a4],
    b: [:b1, :b2, :b3, :b4],
    c: [:c1, :c2, :c3, :c4],
    d: [:d1, :d2, :d3, :d4]
  }
  @start2 [
    a1: :d,
    a4: :c,
    b1: :b,
    b4: :a,
    c1: :d,
    c4: :a,
    d1: :b,
    d4: :c,
    a2: :d,
    a3: :d,
    b2: :c,
    b3: :b,
    c2: :b,
    c3: :a,
    d2: :a,
    d3: :c
  ]

  def solve1 do
    start_pos = {0, Enum.sort(@start)}
    solve_game(@map, @destinations, start_pos, Map.new())
  end

  def solve2 do
    start_pos = {0, Enum.sort(@start2)}
    solve_game(@map2, @destinations2, start_pos, Map.new())
  end

  def solve_game(map, destinations, {cost, pieces}, seen) do
    if win?(destinations, pieces) do
      cost
    else
      new_paths =
        Enum.flat_map(pieces, fn {loc, piece} ->
          others = pieces -- [{loc, piece}]

          for {moveloc, dist} <- possible_moves(map, destinations, others, {loc, piece}),
              newcost = cost + dist * @cost[piece],
              newpieces = Enum.sort([{moveloc, piece} | others]) do
            {newcost, newpieces}
          end
        end)

      seen =
        Enum.reduce(new_paths, seen, fn {cost, pieces}, map ->
          case map do
            %{^pieces => curcost} ->
              if curcost < cost do
                map
              else
                Map.put(map, pieces, cost)
              end

            map ->
              Map.put(map, pieces, cost)
          end
        end)

      {test_pieces, test_cost} =
        Enum.reduce(seen, fn {pieces, cost}, {bestpieces, bestcost} ->
          if cost < bestcost do
            {pieces, cost}
          else
            {bestpieces, bestcost}
          end
        end)

      solve_game(map, destinations, {test_cost, test_pieces}, Map.delete(seen, test_pieces))
    end
  end

  def print_map(pieces) do
    map = Map.new(pieces)

    hallway =
      [:r1, :r2, :r3, :r4, :r5, :r6, :r7, :r8, :r9, :r10, :r11]
      |> Enum.map(fn room -> Map.get(map, room, ".") end)
      |> Enum.join()

    rows = [
      [:a1, :b1, :c1, :d1],
      [:a2, :b2, :c2, :d2],
      [:a3, :b3, :c3, :d3],
      [:a4, :b4, :c4, :d4]
    ]

    row_strings =
      for row <- rows do
        Enum.map(row, fn room -> Map.get(map, room, ".") end)
        |> Enum.intersperse(" ")
        |> Enum.join()
      end

    [hallway | row_strings]
    |> Enum.intersperse("\n  ")
    |> Enum.join()
    |> IO.puts()
  end

  def win?(destinations, pieces) do
    Enum.all?(pieces, fn {loc, piece} -> loc in destinations[piece] end)
  end

  def possible_moves(map, destinations, pieces, {pos, piece}) do
    case final_destination?(destinations, pos, piece, pieces) do
      true ->
        []

      false ->
        moves = accessible(map, pieces, [{pos, 0}])

        case Enum.find(moves, fn {p, _dist} ->
               final_destination?(destinations, p, piece, pieces)
             end) do
          nil ->
            for {p, dist} <- moves,
                p in @hallway,
                p not in @blockers,
                pos not in @hallway do
              {p, dist}
            end

          {p, dist} ->
            [{p, dist}]
        end
    end
  end

  def lower_destinations(pos, [pos | rest]), do: rest
  def lower_destinations(pos, [_ | rest]), do: lower_destinations(pos, rest)

  def final_destination?(destinations, pos, piece, pieces) do
    dest = destinations[piece]

    if pos in dest do
      Enum.all?(lower_destinations(pos, dest), fn d -> {d, piece} in pieces end)
    else
      false
    end
  end

  def accessible(map, pieces, acc) do
    visited = Enum.map(acc, fn {p, _} -> p end)

    neighbors =
      Enum.flat_map(acc, fn {p, dist} -> Enum.map(map[p], fn p -> {p, dist + 1} end) end)
      |> Enum.filter(fn {p, _} -> !occupied?(p, pieces) && p not in visited end)

    case neighbors do
      [] ->
        Enum.filter(acc, fn {_, dist} -> dist != 0 end)

      new_points ->
        accessible(map, pieces, new_points ++ acc)
    end
  end

  def occupied?(pos, pieces) do
    Enum.any?(pieces, fn {occ_pos, _} -> occ_pos == pos end)
  end
end
