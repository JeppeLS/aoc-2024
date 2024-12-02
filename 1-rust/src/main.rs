use std::{fs, iter::zip};

fn main() {
    let input = fs::read_to_string("input.txt").expect("Input file not found");

    let mut list_a: Vec<i64> = Vec::new();
    let mut list_b: Vec<i64> = Vec::new();

    for line in input.lines() {
        let columns: Vec<&str> = line.split("   ").collect();
        list_a.push(columns[0].parse().unwrap());
        list_b.push(columns[1].parse().unwrap());
    }

    list_a.sort();
    list_b.sort();

    println!("{:?}", list_a);

    let distance_sum =
        zip(list_a, list_b).fold(0, |sum, (first, second)| sum + (first - second).abs());

    println!("The answer is {}", distance_sum)
}
