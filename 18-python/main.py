INF = 1_000_000_000_000
falling_bytes = []
with open("input.txt") as f:
    for line in f:
        x, y = line.split(",")
        falling_bytes.append((int(x), int(y)))


bytes_map = [[False for _ in range(71)] for _ in range(71)]
visited = {}

for x, y in falling_bytes[:1024]:
    bytes_map[y][x] = True


def a_star(
    map: list[list[bool]],
    start: tuple[int, int],
    end: tuple[int, int],
) -> list[tuple[int, int]] | None:
    # Manhattan distance
    def heuristic(a, b):
        return abs(a[0] - b[0]) + abs(a[1] - b[1])

    def get_neighbors(node):
        x, y = node
        neighbors = []
        for dx, dy in ((0, 1), (0, -1), (1, 0), (-1, 0)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < 71 and 0 <= ny < 71 and not map[ny][nx]:
                neighbors.append((nx, ny))
        return neighbors

    open_set = {start}
    came_from = {}

    g_score = {start: 0}
    f_score = {start: heuristic(start, end)}

    while open_set:
        current = min(open_set, key=lambda x: f_score[x])

        if current == end:
            path = []
            while current in came_from:
                path.append(current)
                current = came_from[current]
            return path

        open_set.remove(current)
        for neighbor in get_neighbors(current):
            tentative_g_score = g_score[current] + 1
            if tentative_g_score < g_score.get(neighbor, INF):
                came_from[neighbor] = current
                g_score[neighbor] = tentative_g_score
                f_score[neighbor] = tentative_g_score + heuristic(neighbor, end)
                open_set.add(neighbor)

    return None


path = a_star(bytes_map, (0, 0), (70, 70))
assert path is not None, "Path not found"

print(len(path))
