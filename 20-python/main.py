INF = 1_000_000_000_000
with open("input.txt") as f:
    map = f.read().splitlines()

walls = [[True if c == "#" else False for c in row] for row in map]
start = None
end = None
for i in range(len(map)):
    for j in range(len(map[i])):
        if map[i][j] == "S":
            start = (j, i)
        elif map[i][j] == "E":
            end = (j, i)

assert start is not None
assert end is not None

height = len(map)
width = len(map[0])


def create_dist_map(
    walls: list[list[bool]],
    end: tuple[int, int],
) -> list[list[int]]:
    dist_map = [[INF for _ in range(width)] for _ in range(height)]
    dist_map[end[1]][end[0]] = 0
    queue = [end]
    while queue:
        x, y = queue.pop(0)
        for dx, dy in (
            (0, 1),
            (1, 0),
            (0, -1),
            (-1, 0),
        ):
            nx, ny = x + dx, y + dy
            if nx < 0 or nx >= width or ny < 0 or ny >= height:
                continue
            if walls[ny][nx]:
                continue
            if dist_map[ny][nx] != INF:
                continue
            dist_map[ny][nx] = dist_map[y][x] + 1
            queue.append((nx, ny))
    return dist_map


dist_map = create_dist_map(walls, end)
cost = dist_map[start[1]][start[0]]
print(f"Cost: {cost}")
path = [start]
current = start
while current != end:
    x, y = current
    for dx, dy in (
        (0, 1),
        (1, 0),
        (0, -1),
        (-1, 0),
    ):
        nx, ny = x + dx, y + dy
        diff = dist_map[y][x] - dist_map[ny][nx]
        if diff == 1:
            path.append((nx, ny))
            current = (nx, ny)

print(f"Path: {len(path)}")

res = 0
for current_picoseconds, (x, y) in enumerate(path):
    for dx, dy in (
        (0, 2),
        (2, 0),
        (0, -2),
        (-2, 0),
        (1, 1),
        (1, -1),
        (-1, 1),
        (-1, -1),
    ):
        nx, ny = x + dx, y + dy
        if nx < 0 or nx >= width or ny < 0 or ny >= height:
            continue
        if walls[ny][nx]:
            continue

        new_cost = current_picoseconds + 2 + dist_map[ny][nx]
        if new_cost <= cost - 100:
            res += 1

print(f"Result: {res}")
