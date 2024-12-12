defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "example string has 18 XMAS" do
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

    assert Aoc.count_xmas_matches(test_input) == 18
  end

  test "example string has 9 cross-MAS" do
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

    assert Aoc.count_cross_mas_matches(test_input) == 9
  end
end
