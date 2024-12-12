local function read_lines(file)
    local f = io.open(file, "r")
    if not f then
        return nil
    end
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    f:close()
    return lines
end

local function split_result_and_parts(line)
    local colon = string.find(line, ":")
    local result = tonumber(string.sub(line, 1, colon - 1))
    local parts = string.sub(line, colon + 2)
    local numbers = {}
    for number in string.gmatch(parts, "([^%s]+)") do
        table.insert(numbers, tonumber(number))
    end

    return result, numbers
end

local function pop_immutable(arr)
    local first = arr[1]
    local rest = {}
    for i = 2, #arr, 1 do
        rest[#rest + 1] = arr[i]
    end
    return first, rest
end

local function is_solvable_recursive(result, current, numbers, enable_concat)
    if current > result then
        return false
    end
    if #numbers == 0 then
        return current == result
    end

    local next, rest = pop_immutable(numbers)

    if enable_concat then
        local digets = math.ceil(math.log(next + 1, 10))
        local concat = current * math.floor(10 ^ digets) + next
        if is_solvable_recursive(result, concat, rest, enable_concat) then
            return true
        end
    end
    local multiplied = current * next
    if is_solvable_recursive(result, multiplied, rest, enable_concat) then
        return true
    end
    local added = current + next
    if is_solvable_recursive(result, added, rest, enable_concat) then
        return true
    end
    return false
end

local function is_solvable(result, numbers, enable_concat)
    local first, rest = pop_immutable(numbers)

    return is_solvable_recursive(result, first, rest, enable_concat)
end

local input = read_lines("input.txt")

local function main(lines)
    local p1 = 0
    local p2 = 0

    for _, line in pairs(lines) do
        local result, numbers = split_result_and_parts(line)

        if is_solvable(result, numbers, false) then
            p1 = p1 + result
            -- Also solvable with concat
            p2 = p2 + result
        elseif is_solvable(result, numbers, true) then
            p2 = p2 + result
        end
    end
    return p1, p2
end

local p1, p2 = main(input)
print("Part 1: ", p1)
print("Part 2: ", p2)
