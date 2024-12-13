require "minitest/autorun"
require "./main.rb"


class TestCountCorners < Minitest::Test
  def test_single_count_corners()
    map = [["X"]]

    expected = [Set[[0, 0], [0, 1], [1, 0], [1, 1]], []]
    assert_equal(expected, count_corners(map, 0, 0))
  end

  def test_middle_count_corners()
    map = [
      ["X", "X", "X"],
      ["X", "O", "X"],
      ["X", "X", "X"]
    ]

    expected = [Set[[1, 1], [1, 2], [2, 2], [2, 1]], []]
    assert_equal(expected, count_corners(map, 1, 1))
  end

  def test_2x2_count_corners()
    map = [
      ["X", "X"],
      ["X", "X"]
    ]

    expected = [Set[[2, 2]], []]
    assert_equal(expected, count_corners(map, 1, 1))
  end
end

class TestCountCornersInRegion < Minitest::Test
  def test_single_count_corners()
    map = [["X"]]

    expected = 4
    _, _, corners, special_cases = calculate_fence_price_for_region(map, 0, 0, Set.new())
    n_corners = corners.length + special_cases.tally.values.count(2)
    assert_equal(expected, n_corners)
  end

  def test_middle_count_corners()
    map = [
      ["X", "X", "X"],
      ["X", "O", "X"],
      ["X", "X", "X"]
    ]

    expected = 4
    _, _, corners, special_cases = calculate_fence_price_for_region(map, 1, 1, Set.new())
    n_corners = corners.length + special_cases.tally.values.count(2)
    assert_equal(expected, n_corners)
  end

  def test_2x2_count_corners()
    map = [
      ["X", "X"],
      ["X", "X"]
    ]

    expected = 4
    _, _, corners, special_cases = calculate_fence_price_for_region(map, 0, 0, Set.new())
    n_corners = corners.length + special_cases.tally.values.count(2)
    assert_equal(expected, n_corners)
  end

  def test_count_same_corner_twice_if_diagonal()
    map = [
      ["O", "X", "X"],
      ["X", "O", "X"],
      ["X", "X", "X"]
    ]

    expected = 10
    _, _, corners, special_cases = calculate_fence_price_for_region(map, 0, 1, Set.new())
    n_corners = corners.length + special_cases.tally.values.count(2)
    assert_equal(expected, n_corners)
  end
end
