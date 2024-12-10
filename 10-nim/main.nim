import std/strutils
import std/sequtils
import std/sets

type
    Coord = object
        i, j: int

let input = readFile("input.txt")
let lines = input.splitLines().filterIt(it.len() > 0)

let size = lines.len()
let width = lines[0].len()

proc find_trail_heads(lines: seq[string], i: int, j: int): HashSet[Coord] =
    result = initHashSet[Coord]()
    let current = lines[i][j]
    if current == '9':
        let trailhead = Coord(i: i, j: j)
        result.incl(trailhead)

    let next = char(int(current) + 1)
    if i > 0 and lines[i - 1][j] == next:
        result.incl(find_trail_heads(lines, i - 1, j))
    if i < lines.high() and lines[i + 1][j] == next:
        result.incl(find_trail_heads(lines, i + 1, j))
    if j > 0 and lines[i][j - 1] == next:
        result.incl(find_trail_heads(lines, i, j - 1))
    if j < lines[0].len() - 1 and lines[i][j + 1] == next:
        result.incl(find_trail_heads(lines, i, j + 1))

proc find_trail_ratings(lines: seq[string], i: int, j: int): int =
    let current = lines[i][j]
    if current == '9':
        return 1

    result = 0
    let next = char(int(current) + 1)
    if i > 0 and lines[i - 1][j] == next:
        result += find_trail_ratings(lines, i - 1, j)
    if i < lines.high() and lines[i + 1][j] == next:
        result += find_trail_ratings(lines, i + 1, j)
    if j > 0 and lines[i][j - 1] == next:
        result += find_trail_ratings(lines, i, j - 1)
    if j < lines[0].len() - 1 and lines[i][j + 1] == next:
        result += find_trail_ratings(lines, i, j + 1)

var trailhead_sum = 0
var trail_rating_sum = 0
for i in 0 ..< size:
    for j in 0 ..< width:
        let c = lines[i][j]
        if c != '0':
            continue
        let trailheads = find_trailheads(lines, i, j)
        let trail_ratings = find_trail_ratings(lines, i, j)
        trailhead_sum += trailheads.len()
        trail_rating_sum += trail_ratings


echo "Trailheads: ", trailhead_sum
echo "Trail ratings: ", trail_rating_sum
