require 'set'

def calculate_fence_price_for_region(map, i, j, seen)
  if seen.include?([i, j])
    return [0, 0, Set.new(), []]
  end

  seen.add([i, j])
  current = map[i][j]

  coords = [
    [i, j-1],
    [i, j+1],
    [i-1, j],
    [i+1, j]
  ]

  total_area = 1
  total_perimeter = 4
  corners, special_cases = count_corners(map, i, j)
  for next_i, next_j in coords
    cell = get_cell_or_nil(map, next_i, next_j)
    if cell != current
      next
    end

    total_perimeter -= 1

    area, perimeter, further_corners, further_special_cases = calculate_fence_price_for_region(map, next_i, next_j, seen)
    corners.merge(further_corners)
    special_cases.concat(further_special_cases)
    total_area += area
    total_perimeter += perimeter
  end

  [total_area, total_perimeter, corners, special_cases]
end

def calculate_total_fence_price(map)
  p1 = 0
  p2 = 0
  seen = Set.new()
  for i in 0..map.length-1
    for j in 0..map[i].length-1
      area, perimeter, corners, special_cases = calculate_fence_price_for_region(map, i, j, seen)
      tricky_diag_corners = special_cases.tally.values.count(2)
      n_corners = corners.length + tricky_diag_corners

      p1 += area * perimeter
      p2 += area * n_corners
    end
  end

  [p1, p2]
end

def get_cell_or_nil(map, i, j)
  if i < 0 || j < 0
    return nil
  end

  row = map[i]
  if row == nil
    return nil
  end

  row[j]
end

def count_corners(map, i, j)
  current = map[i][j]

  upper_left = get_cell_or_nil(map, i-1, j-1)
  upper = get_cell_or_nil(map, i-1, j)
  upper_right = get_cell_or_nil(map, i-1, j+1)
  right = get_cell_or_nil(map, i, j+1)
  lower_right = get_cell_or_nil(map, i+1, j+1)
  lower = get_cell_or_nil(map, i+1, j)
  lower_left = get_cell_or_nil(map, i+1, j-1)
  left = get_cell_or_nil(map, i, j-1)

  corners = Set.new()
  special_cases = []

  # Define corner coordinate by square that has corner in upper left corner
  #
  # Check if upper left is corner
  if current == left && current == upper && current != upper_left
    corners.add([i, j])
  elsif current != left && current != upper
    if current == upper_left
      # This is actually 2 two corners if X share region
      # X | Y
      # - . -
      # Y | X
      corners.add([i, j])
      special_cases.push([i, j])
    else
      corners.add([i, j])
    end
  end

  # Upper right
  if current == right && current == upper && current != upper_right
    corners.add([i, j+1])
  elsif current != right && current != upper
    if current == upper_right
      corners.add([i, j+1])
      special_cases.push([i, j+1])
    else
      corners.add([i, j+1])
    end
  end

  # Lower right
  if current == right && current == lower && current != lower_right
    corners.add([i+1, j+1])
  elsif current != right && current != lower
    if current == lower_right
      corners.add([i+1, j+1])
      special_cases.push([i+1, j+1])
    else
      corners.add([i+1, j+1])
    end
  end

  # Lower left
  if current == left && current == lower && current != lower_left
    corners.add([i+1, j])
  elsif current != left && current != lower
    if current == lower_left
      corners.add([i+1, j])
      special_cases.push([i+1, j])
    else
      corners.add([i+1, j])
    end
  end

  [corners, special_cases]
end



if __FILE__ == $0
  input = File.read('input.txt').split("\n").map do |line| line.chars end
  p1, p2= calculate_total_fence_price(input)


  puts "Part 1: #{p1}"
  puts "Part 2: #{p2}"
end
