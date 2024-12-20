use std::{
    collections::{HashMap, VecDeque},
    fs,
};

#[derive(Clone, Copy, PartialEq, Hash, Eq)]
enum Direction {
    Up,
    Right,
    Down,
    Left,
}

struct Path {
    position: Position,
    cost: usize,
}

#[derive(Eq, Hash, PartialEq, Clone)]
struct Position {
    row: usize,
    col: usize,
    direction: Direction,
}

enum Field {
    Empty,
    Wall,
    End,
    Start,
}

fn main() {
    let input = fs::read_to_string("test_input.txt").expect("Input file not found");

    let map: Vec<Vec<Field>> = input
        .split("\n")
        .map(|line| {
            line.chars()
                .map(|c| match c {
                    '.' => Field::Empty,
                    '#' => Field::Wall,
                    'E' => Field::End,
                    'S' => Field::Start,
                    _ => panic!("Invalid character in map"),
                })
                .collect::<Vec<Field>>()
        })
        .collect();

    let start = find_start(&map);

    let result = find_cheapest_path(&map, start);

    println!("Result: {}", result);
}

fn find_start(map: &Vec<Vec<Field>>) -> Path {
    for (i, row) in map.iter().enumerate() {
        for (j, field) in row.iter().enumerate() {
            if let Field::Start = field {
                let position = Position {
                    row: i,
                    col: j,
                    direction: Direction::Right,
                };
                return Path { position, cost: 0 };
            }
        }
    }

    panic!("No start found");
}

fn find_cheapest_path(map: &Vec<Vec<Field>>, start: Path) -> usize {
    let mut memory: HashMap<Position, usize> = HashMap::new();

    let mut paths = VecDeque::new();
    let mut best = usize::MAX;
    paths.push_back(start);
    loop {
        match paths.pop_back() {
            Some(path) => {
                if path.cost > best {
                    continue;
                }
                let possible_decisions = get_possible_decisions(&path, &map);
                for decision in possible_decisions {
                    let position = decision.position.clone();
                    let row = position.row;
                    let col = position.col;
                    let cost = decision.cost;
                    if decision.cost < *memory.get(&position).unwrap_or(&usize::MAX) {
                        memory.insert(position, decision.cost);
                        paths.push_front(decision);
                    }

                    if let Field::End = map[row][col] {
                        if cost < best {
                            best = cost;
                        }
                    }
                }
            }
            None => break,
        }
    }
    best
}

fn get_possible_decisions(path: &Path, map: &Vec<Vec<Field>>) -> Vec<Path> {
    let mut possible_decisions = Vec::new();
    for direction in vec![
        Direction::Up,
        Direction::Right,
        Direction::Down,
        Direction::Left,
    ] {
        if let Some(next_path) = get_next_path(&path, direction, &map) {
            possible_decisions.push(next_path);
        }
    }
    return possible_decisions;
}

fn get_next_path(path: &Path, decision: Direction, map: &Vec<Vec<Field>>) -> Option<Path> {
    let position = &path.position;
    let row: usize = match decision {
        Direction::Up => (position.row as i32 - 1).try_into().ok(),
        Direction::Right => Some(position.row),
        Direction::Down => Some(position.row + 1),
        Direction::Left => Some(position.row),
    }?;

    if row >= map.len() {
        return None;
    }

    let col: usize = match decision {
        Direction::Up => Some(position.col),
        Direction::Right => Some(position.col + 1),
        Direction::Down => Some(position.col),
        Direction::Left => (position.col as i32 - 1).try_into().ok(),
    }?;
    if col >= map[0].len() {
        return None;
    }

    let field = &map[row][col];

    match field {
        Field::Empty | Field::End => {
            let next_position = Position {
                row,
                col,
                direction: decision,
            };
            Some(Path {
                position: next_position,
                cost: path.cost + 1 + 1000 * spins(position.direction, decision),
            })
        }
        _ => None,
    }
}

fn spins(from: Direction, to: Direction) -> usize {
    match from {
        Direction::Up => match to {
            Direction::Left => 1,
            Direction::Right => 1,
            Direction::Down => 2,
            Direction::Up => 0,
        },
        Direction::Right => match to {
            Direction::Left => 2,
            Direction::Right => 0,
            Direction::Down => 1,
            Direction::Up => 1,
        },
        Direction::Down => match to {
            Direction::Left => 1,
            Direction::Right => 1,
            Direction::Down => 0,
            Direction::Up => 2,
        },
        Direction::Left => match to {
            Direction::Left => 0,
            Direction::Right => 2,
            Direction::Down => 1,
            Direction::Up => 1,
        },
    }
}
