from functools import lru_cache

with open("input.txt") as f:
    lines = f.read().splitlines()

patterns = [p for p in lines[0].split(", ")]
designs = [d for d in lines[2:]]


def match_design(patterns, design):
    for pattern in patterns:
        sub = design[: len(pattern)]
        if sub == pattern:
            if sub == design:
                return [pattern]
            else:
                selected = match_design(patterns, design[len(pattern) :])
                if selected is not None:
                    return [pattern] + selected
    return None


matches = []
for design in designs:
    match = match_design(patterns, design)
    if match is not None:
        matches.append(match)

print(len(matches))


@lru_cache
def match_all_designs(patterns, design):
    all_matches = 0
    for pattern in patterns:
        sub = design[: len(pattern)]
        if sub == pattern:
            if len(sub) == len(design):
                all_matches += 1
            else:
                all_matches += match_all_designs(patterns, design[len(pattern) :])
    return all_matches


matches = 0
for design in designs:
    n = match_all_designs(tuple(patterns), design)
    matches += n

print(matches)
