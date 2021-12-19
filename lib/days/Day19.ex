defmodule Aoc2021Ex.Day19 do
  use Aoc2021Ex.Day

  def solve1 do
    parsed_input()
    |> Map.values()
    |> collapse()
  end

  def solve2 do
    :ok
  end

  def collapse([first | rest]), do: collapse(first, rest, [], [])
  def collapse(into, [], [], acc), do: {into, acc}
  def collapse(into, [], tried, acc), do: collapse(into, tried, [], acc)

  def collapse(into, [set | rest], tried, acc) do
    IO.inspect(l: length(rest) + 1, t: length(tried))

    case detect_overlap(into, set) do
      nil ->
        collapse(into, rest, [set | tried], acc)

      {_, collapsed, dist} ->
        collapse(collapsed, rest, tried, [dist | acc])
    end
  end

  def equiv({x, y, z}) do
    [{x, y, z}, {-y, x, z}, {-x, -y, z}, {y, -x, z}, {-z, y, x}, {z, y, -x}]
    |> Enum.flat_map(&rot/1)
  end

  def rot({x, y, z}) do
    [{x, y, z}, {x, z, -y}, {x, -y, -z}, {x, -z, y}]
  end

  @spec parsed_input :: map
  def parsed_input do
    test_input()
    |> String.split("\n\n")
    |> Enum.map(&parse_scanner/1)
    |> Map.new()
  end

  def manhattan({x1, y1, z1}, {x2, y2, z2}) do
    abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
  end

  def pairwise_manhattan(points) do
    for a <- points,
        b <- points do
          manhattan(a, b)
        end
  end

  def parse_scanner(scanner) do
    [scanner | points] = String.split(scanner, "\n")

    scanner =
      String.split(scanner)
      |> Enum.at(2)
      |> String.to_integer()

    points =
      for line <- points,
          coords = String.split(line, ","),
          [x, y, z] = Enum.map(coords, &String.to_integer/1) do
        {x, y, z}
      end

    {scanner, points}
  end

  def detect_overlap(pointsa, pointsb) do
    Enum.reduce_while(pointsa, nil, fn a, acc ->
      Enum.reduce_while(pointsb, acc, fn b, acc ->
        {xa, ya, za} = a
        {xb, yb, zb} = b
        {dx, dy, dz} = {xa - xb, ya - yb, za - zb}

        bdiffs =
          for {x, y, z} <- pointsb do
            {x - xb, y - yb, z - zb}
          end

        rotated_b_sets =
          Enum.map(bdiffs, &equiv/1)
          |> Enum.zip()
          |> Enum.map(&Tuple.to_list/1)
          |> Enum.map(fn diffs ->
            for {ddx, ddy, ddz} <- diffs do
              {xb + dx + ddx, yb + dy + ddy, zb + dz + ddz}
            end
          end)

        Enum.reduce_while(rotated_b_sets, acc, fn rotation, _ ->
          dups = overlaps(pointsa, rotation)

          if length(dups) >= 12 do
            {:halt, {dups, Enum.uniq(pointsa ++ rotation), {dx, dy, dz}}}
          else
            {:cont, nil}
          end
        end)
        |> wrap_reduce()
      end)
      |> wrap_reduce()
    end)
  end

  def wrap_reduce(result) do
    case result do
      nil ->
        {:cont, nil}

      result ->
        {:halt, result}
    end
  end

  def num_overlaps(set1, set2) do
    length(set1) - length(set1 -- set2)
  end

  def overlaps(set1, set2) do
    for x <- set1, x in set2, do: x
  end

  def test_input do
    """
    --- scanner 0 ---
    404,-588,-901
    528,-643,409
    -838,591,734
    390,-675,-793
    -537,-823,-458
    -485,-357,347
    -345,-311,381
    -661,-816,-575
    -876,649,763
    -618,-824,-621
    553,345,-567
    474,580,667
    -447,-329,318
    -584,868,-557
    544,-627,-890
    564,392,-477
    455,729,728
    -892,524,684
    -689,845,-530
    423,-701,434
    7,-33,-71
    630,319,-379
    443,580,662
    -789,900,-551
    459,-707,401

    --- scanner 1 ---
    686,422,578
    605,423,415
    515,917,-361
    -336,658,858
    95,138,22
    -476,619,847
    -340,-569,-846
    567,-361,727
    -460,603,-452
    669,-402,600
    729,430,532
    -500,-761,534
    -322,571,750
    -466,-666,-811
    -429,-592,574
    -355,545,-477
    703,-491,-529
    -328,-685,520
    413,935,-424
    -391,539,-444
    586,-435,557
    -364,-763,-893
    807,-499,-711
    755,-354,-619
    553,889,-390

    --- scanner 2 ---
    649,640,665
    682,-795,504
    -784,533,-524
    -644,584,-595
    -588,-843,648
    -30,6,44
    -674,560,763
    500,723,-460
    609,671,-379
    -555,-800,653
    -675,-892,-343
    697,-426,-610
    578,704,681
    493,664,-388
    -671,-858,530
    -667,343,800
    571,-461,-707
    -138,-166,112
    -889,563,-600
    646,-828,498
    640,759,510
    -630,509,768
    -681,-892,-333
    673,-379,-804
    -742,-814,-386
    577,-820,562

    --- scanner 3 ---
    -589,542,597
    605,-692,669
    -500,565,-823
    -660,373,557
    -458,-679,-417
    -488,449,543
    -626,468,-788
    338,-750,-386
    528,-832,-391
    562,-778,733
    -938,-730,414
    543,643,-506
    -524,371,-870
    407,773,750
    -104,29,83
    378,-903,-323
    -778,-728,485
    426,699,580
    -438,-605,-362
    -469,-447,-387
    509,732,623
    647,635,-688
    -868,-804,481
    614,-800,639
    595,780,-596

    --- scanner 4 ---
    727,592,562
    -293,-554,779
    441,611,-461
    -714,465,-776
    -743,427,-804
    -660,-479,-426
    832,-632,460
    927,-485,-438
    408,393,-506
    466,436,-512
    110,16,151
    -258,-428,682
    -393,719,612
    -211,-452,876
    808,-476,-593
    -575,615,604
    -485,667,467
    -680,325,-822
    -627,-443,-432
    872,-547,-609
    833,512,582
    807,604,487
    839,-516,451
    891,-625,532
    -652,-548,-490
    30,-46,-14
    """
    |> String.trim()
  end
end
