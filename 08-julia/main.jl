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

function in_bounds(coord::Coord, width::Int, height::Int)
    return 1 <= coord.row <= height && 1 <= coord.col <= width
end

function place_left_antinode(
    left::Coord,
    right::Coord,
    width::Int,
    height::Int,
)
    row_diff = abs(left.row - right.row)
    col_diff = abs(left.col - right.col)

    left_col = left.col - col_diff

    left_row = 0
    if left.row < right.row
        left_row = left.row - row_diff
    else
        left_row = left.row + row_diff
    end

    left_antinode = Coord(left_row, left_col)
    if !in_bounds(left_antinode, width, height)
        return nothing
    end

    return left_antinode
end

function place_right_antinode(
    left::Coord,
    right::Coord,
    width::Int,
    height::Int,
)
    row_diff = abs(left.row - right.row)
    col_diff = abs(left.col - right.col)

    right_col = right.col + col_diff

    right_row = 0
    if left.row < right.row
        right_row = right.row + row_diff
    else
        right_row = right.row - row_diff
    end

    right_antinode = Coord(right_row, right_col)
    if !in_bounds(right_antinode, width, height)
        return nothing
    end

    return right_antinode

end

function place_left_antinodes(
    left::Coord,
    right::Coord,
    width::Int,
    height::Int,
)
    antinodes = []
    while true
        left_antinode = place_left_antinode(left, right, width, height)
        if left_antinode === nothing
            break
        end
        push!(antinodes, left_antinode)
        right = left
        left = left_antinode
    end
    return antinodes
end

function place_right_antinodes(
    left::Coord,
    right::Coord,
    width::Int,
    height::Int,
)
    antinodes = []
    while true
        right_antinode = place_right_antinode(left, right, width, height)
        if right_antinode === nothing
            break
        end
        push!(antinodes, right_antinode)
        left = right
        right = right_antinode
    end
    return antinodes
end

p1_antinodes = Set{Coord}()
p2_antinodes = Set{Coord}()

for (antenna, coords) in antenna_dict
    for c1 in coords
        for c2 in coords
            if c1 == c2
                continue
            end

            if c1.col < c2.col
                left = place_left_antinodes(c1, c2, width, height)
                right = place_right_antinodes(c1, c2, width, height)
            else
                left = place_left_antinodes(c2, c1, width, height)
                right = place_right_antinodes(c2, c1, width, height)
            end

            if length(left) >= 1
                push!(p1_antinodes, left[1])
            end
            for i in left
                push!(p2_antinodes, i)
            end

            if length(right) >= 1
                push!(p1_antinodes, right[1])
            end
            for i in right
                push!(p2_antinodes, i)
            end

            push!(p2_antinodes, c1, c2)
        end
    end
end

println(length(p1_antinodes))
println(length(p2_antinodes))
