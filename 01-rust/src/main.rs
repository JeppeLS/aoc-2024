use std::{collections::HashMap, fs, iter::zip};

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

    let distance_sum = calc_pairwise_dict_sum(&list_a, &list_b);
    println!("The distance sum is {}", distance_sum);

    let similarity_score = calc_similarity_score(&list_a, &list_b);
    println!("The similarity score is {}", similarity_score)
}

fn calc_pairwise_dict_sum(list_a: &[i64], list_b: &[i64]) -> i64 {
    return zip(list_a, list_b).fold(0, |sum, (first, second)| sum + (first - second).abs());
}

fn calc_similarity_score(list_a: &[i64], list_b: &[i64]) -> i64 {
    let occurences = list_b.into_iter().fold(HashMap::new(), |mut map, number| {
        let entry = map.entry(number).or_insert(0);
        *entry += 1;
        map
    });

    return list_a.into_iter().fold(0, |sum, number| {
        let score = occurences.get(number).unwrap_or(&0);

        sum + score * number
    });
}
