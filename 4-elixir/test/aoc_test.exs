defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "example string has 18 matches" do
    test_input = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

    assert Aoc.count_matches(test_input) == 18
  end
end
