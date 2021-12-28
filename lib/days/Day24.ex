defmodule Aoc2021Ex.Day24 do
  use Aoc2021Ex.Day

  @start_state %{w: 0, x: 0, y: 0, z: 0}

  def solve1, do: solve_stages(:max)
  def solve2, do: solve_stages(:min)

  def solve_stages(min_max \\ :max) do
    staged = split_stages(program())

    Enum.reduce(staged, %{0 => 0}, fn stage, zvals ->
      for input <- 1..9,
          {zval, prev_input} <- zvals,
          start_state = Map.put(@start_state, :z, zval),
          end_zval = Map.get(interpret(stage, start_state, [input]), :z),
          full_input = prev_input * 10 + input,
          reduce: %{} do
        new_zvals = %{^end_zval => inp} when min_max == :max and full_input > inp ->
          Map.put(new_zvals, end_zval, full_input)

        new_zvals = %{^end_zval => inp} when min_max == :min and full_input < inp ->
          Map.put(new_zvals, end_zval, full_input)

        new_zvals ->
          Map.put_new(new_zvals, end_zval, full_input)
      end
      |> tap(fn map -> IO.puts(map_size(map)) end)
    end)
  end

  def interpret([], state, _), do: state

  def interpret(_program = [_instr = {op, arg1, arg2} | rest], state, input) do
    v1 = Map.get(state, arg1)
    v2 = Map.get(state, arg2, arg2)

    # IO.inspect(state: state)
    # IO.puts(debug_instr(instr, state, input))

    case op do
      :inp ->
        [inp | rest_inp] = input
        state = Map.put(state, arg1, inp)
        interpret(rest, state, rest_inp)

      :add ->
        state = Map.put(state, arg1, v1 + v2)
        interpret(rest, state, input)

      :mul ->
        state = Map.put(state, arg1, v1 * v2)
        interpret(rest, state, input)

      :div ->
        state = Map.put(state, arg1, div(v1, v2))
        interpret(rest, state, input)

      :mod ->
        state = Map.put(state, arg1, rem(v1, v2))
        interpret(rest, state, input)

      :eql ->
        v = if v1 == v2, do: 1, else: 0
        state = Map.put(state, arg1, v)
        interpret(rest, state, input)
    end
  end

  def debug_instr({op, a1, a2}, state, inp) do
    v1 = Map.get(state, a1)
    v2 = Map.get(state, a2, a2)

    a2_dbg =
      if Map.has_key?(state, a2) do
        "#{a2} (#{v2})"
      else
        v2
      end

    case op do
      :inp ->
        inp = hd(inp)
        "#{a1} <- #{inp} (input)"

      :add ->
        "#{a1} += #{a2_dbg};  #{a1}: #{v1} -> #{v1 + v2}"

      :mul ->
        "#{a1} *= #{a2_dbg};  #{a1}: #{v1} -> #{v1 * v2}"

      :div ->
        "#{a1} /= #{a2_dbg};  #{a1}: #{v1} -> #{div(v1, v2)}"

      :mod ->
        "#{a1} %= #{a2_dbg};  #{a1}: #{v1} -> #{rem(v1, v2)}"

      :eql ->
        v = if v1 == v2, do: 1, else: 0
        "#{a1} = #{a1}(#{v1}) == #{a2_dbg} ? 1 : 0;  #{a1}: #{v1} -> #{v}"
    end
  end

  def program do
    input_lines()
    |> Enum.map(&parse_instruction/1)
  end

  def parse_instruction(line) do
    [opcode, arg1 | maybe_arg2] = String.split(line, " ")
    opcode = String.to_atom(opcode)
    arg1 = String.to_atom(arg1)

    case maybe_arg2 do
      [] ->
        {opcode, arg1, nil}

      [arg2] ->
        arg2 =
          case Integer.parse(arg2) do
            :error ->
              String.to_atom(arg2)

            {i, _} ->
              i
          end

        {opcode, arg1, arg2}
    end
  end

  def split_stages(prog) do
    split_stages(prog, [], [])
  end

  def split_stages([], stage, acc) do
    [[] | result] = Enum.reverse([Enum.reverse(stage) | acc])
    result
  end

  def split_stages(_prog = [instr = {op, _, _} | rest], stage, acc) do
    case op do
      :inp ->
        split_stages(rest, [instr], [Enum.reverse(stage) | acc])

      _ ->
        split_stages(rest, [instr | stage], acc)
    end
  end
end
