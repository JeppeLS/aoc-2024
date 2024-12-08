struct Coord
    row::Int
    col::Int
end

function parse_line(line::String, row::Int, antenna_dict::Dict{Char,Vector{Coord}})
    for (col, char) in enumerate(line)
        if char == '.'
            continue
        end
        antenna = get!(antenna_dict, char, Vector{Coord}())
        push!(antenna, Coord(row, col))
    end
end

input = open("input.txt") |> readlines

antenna_dict = Dict{Char,Vector{Coord}}()
width = length(input[1])
height = length(input)
for (row, line) in enumerate(input)
    parse_line(line, row, antenna_dict)
end


function place_antinodes(left::Coord, right::Coord)
    row_diff = abs(left.row - right.row)
    col_diff = abs(left.col - right.col)

    left_col = left.col - col_diff
    right_col = right.col + col_diff

    left_row = 0
    right_row = 0
    if left.row < right.row
        left_row = left.row - row_diff
        right_row = right.row + row_diff
    else
        left_row = left.row + row_diff
        right_row = right.row - row_diff
    end

    return Coord(left_row, left_col), Coord(right_row, right_col)
end

function in_bounds(coord::Coord, width::Int, height::Int)
    return 1 <= coord.row <= height && 1 <= coord.col <= width
end


antinodes = Set{Coord}()

for (antenna, coords) in antenna_dict
    for c1 in coords
        for c2 in coords
            if c1 == c2
                continue
            end

            if c1.col < c2.col
                left, right = place_antinodes(c1, c2)
            else
                left, right = place_antinodes(c2, c1)
            end

            if in_bounds(left, width, height)
                push!(antinodes, left)
            end

            if in_bounds(right, width, height)
                push!(antinodes, right)
            end
        end
    end
end

println(length(antinodes))
