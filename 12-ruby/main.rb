require 'set'

def calculate_fence_price_for_region(map, i, j, seen)
  if seen.include?([i, j])
    return [0, 0]
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
  for next_i, next_j in coords
    if next_i < 0 || next_j < 0
      next
    end

    row = map[next_i]
    if row == nil
      next
    end
    col = row[next_j]
    if col != current
      next
    end

    total_perimeter -= 1

    area, perimeter = calculate_fence_price_for_region(map, next_i, next_j, seen)
    total_area += area
    total_perimeter += perimeter
  end

  [total_area, total_perimeter]
end

def calculate_total_fence_price(map)
  res = 0
  seen = Set.new()
  for i in 0..map.length-1
    for j in 0..map[i].length-1
      area, perimeter = calculate_fence_price_for_region(map, i, j, seen)
      res += area * perimeter
    end
  end

  res
end



if __FILE__ == $0
  input = File.read('input.txt').split("\n").map do |line| line.chars end
  res = calculate_total_fence_price(input)

  puts res
end
