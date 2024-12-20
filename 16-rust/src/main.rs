use std::{
    collections::{BinaryHeap, HashMap, HashSet, VecDeque},
    fs,
};

#[derive(Clone, Copy, PartialEq, Hash, Eq)]
enum Direction {
    Up,
    Right,
    Down,
    Left,
}

#[derive(Clone, Eq, PartialEq)]
struct Path {
    position: Position,
    visited: HashSet<Cell>,
    cost: usize,
}

#[derive(Eq, Hash, PartialEq, Clone)]
struct Position {
    cell: Cell,
    direction: Direction,
}

#[derive(Eq, Hash, PartialEq, Clone)]
struct Cell {
    row: usize,
    col: usize,
}

enum Field {
    Empty,
    Wall,
    End,
    Start,
}

impl Ord for Path {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        other.cost.cmp(&self.cost)
    }
}

impl PartialOrd for Path {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

struct Solution {
    part_one: usize,
    part_two: usize,
}

fn main() {
    let input = fs::read_to_string("input.txt").expect("Input file not found");

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

    println!("Part one: {}", result.part_one);
    println!("Part two: {}", result.part_two);
}

fn find_start(map: &Vec<Vec<Field>>) -> Path {
    for (i, row) in map.iter().enumerate() {
        for (j, field) in row.iter().enumerate() {
            if let Field::Start = field {
                let cell = Cell { row: i, col: j };
                let position = Position {
                    cell: cell.clone(),
                    direction: Direction::Right,
                };
                let mut visited = HashSet::new();
                visited.insert(cell);
                return Path {
                    position,
                    cost: 0,
                    visited,
                };
            }
        }
    }

    panic!("No start found");
}

fn find_cheapest_path(map: &Vec<Vec<Field>>, start: Path) -> Solution {
    let mut memory: HashMap<Position, Path> = HashMap::new();

    let mut paths = BinaryHeap::new();
    let mut best = usize::MAX;
    let mut visited = HashSet::new();
    paths.push(start);
    while let Some(path) = paths.pop() {
        if path.cost > best {
            continue;
        }
        let possible_decisions = get_possible_decisions(&path, &map);
        for mut decision in possible_decisions {
            let position = decision.position.clone();
            let row = position.cell.row;
            let col = position.cell.col;
            let cost = decision.cost;
            if let Some(old) = memory.get(&position) {
                if decision.cost > old.cost {
                    continue;
                }

                old.visited.iter().for_each(|cell| {
                    decision.visited.insert(cell.clone());
                });
            }

            memory.insert(position, decision.clone());
            paths.push(decision.clone());

            if let Field::End = map[row][col] {
                if cost < best {
                    println!("New best: {}", cost);
                    best = cost;
                    visited.clear();
                    decision.visited.iter().for_each(|cell| {
                        visited.insert(cell.clone());
                    });
                } else if cost == best {
                    println!("Equal best: {}", cost);
                    decision.visited.iter().for_each(|cell| {
                        visited.insert(cell.clone());
                    });
                }
            }
        }
    }
    Solution {
        part_one: best,
        part_two: visited.len(),
    }
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
    let cell = &position.cell;
    let row: usize = match decision {
        Direction::Up => (cell.row as i32 - 1).try_into().ok(),
        Direction::Right => Some(cell.row),
        Direction::Down => Some(cell.row + 1),
        Direction::Left => Some(cell.row),
    }?;

    if row >= map.len() {
        return None;
    }

    let col: usize = match decision {
        Direction::Up => Some(cell.col),
        Direction::Right => Some(cell.col + 1),
        Direction::Down => Some(cell.col),
        Direction::Left => (cell.col as i32 - 1).try_into().ok(),
    }?;
    if col >= map[0].len() {
        return None;
    }

    let field = &map[row][col];

    match field {
        Field::Empty | Field::End => {
            let next_cell = Cell { row, col };
            let next_position = Position {
                cell: next_cell.clone(),
                direction: decision,
            };
            let mut visited = path.visited.clone();
            visited.insert(next_cell);

            Some(Path {
                position: next_position,
                cost: path.cost + 1 + 1000 * spins(position.direction, decision),
                visited,
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
