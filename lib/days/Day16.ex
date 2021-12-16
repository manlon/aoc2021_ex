defmodule Aoc2021Ex.Day16 do
  use Aoc2021Ex.Day

  def solve1, do: version_sum(parse_input_program())
  def solve2, do: compute(parse_input_program())

  def parse_input_program do
    input()
    |> Base.decode16!()
    |> consume_packet()
    |> elem(0)
  end

  def consume_packet(<<version::3, 4::3, rest::bitstring>>) do
    {lit, rest} = consume_literal(rest, 0)
    {{version, 4, lit}, rest}
  end

  def consume_packet(<<version::3, typid::3, 0::1, subpack_len::15, rest::bitstring>>) do
    <<subpacket_data::bitstring-size(subpack_len), rest::bitstring>> = rest
    {subpackets, _} = consume_upto(subpacket_data)
    {{version, typid, subpackets}, rest}
  end

  def consume_packet(<<version::3, typid::3, 1::1, num_subs::11, rest::bitstring>>) do
    {subs, rest} = consume_upto(rest, num_subs)
    {{version, typid, subs}, rest}
  end

  def consume_upto(data, upto \\ :infinity, n \\ 0, acc \\ [])
  def consume_upto("", _, _, acc), do: {Enum.reverse(acc), ""}
  def consume_upto(data, n, n, acc), do: {Enum.reverse(acc), data}
  def consume_upto(data, upto, n, acc) do
    {pkt, rest} = consume_packet(data)
    consume_upto(rest, upto, n + 1, [pkt | acc])
  end

  def consume_literal(<<1::1, val::4, rest::bitstring>>, acc) do
    consume_literal(rest, acc * 16 + val)
  end

  def consume_literal(<<0::1, val::4, rest::bitstring>>, acc) do
    {acc * 16 + val, rest}
  end

  def version_sum(tree) do
    case tree do
      {vers, _, subs} when is_list(subs) ->
        vers + Enum.sum(Enum.map(subs, &version_sum/1))

      {vers, _, _} ->
        vers
    end
  end

  def compute({_, 0, packets}), do: Enum.sum(for p <- packets, do: compute(p))
  def compute({_, 1, packets}), do: Enum.product(for p <- packets, do: compute(p))
  def compute({_, 2, packets}), do: Enum.min(for p <- packets, do: compute(p))
  def compute({_, 3, packets}), do: Enum.max(for p <- packets, do: compute(p))
  def compute({_, 4, lit}), do: lit
  def compute({_, 5, [a, b]}), do: (compute(a) > compute(b) && 1) || 0
  def compute({_, 6, [a, b]}), do: (compute(a) < compute(b) && 1) || 0
  def compute({_, 7, [a, b]}), do: (compute(a) == compute(b) && 1) || 0
end
