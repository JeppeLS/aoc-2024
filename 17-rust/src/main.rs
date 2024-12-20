use std::fs;

fn main() {
    let input = fs::read_to_string("input.txt").unwrap();
    let lines = input.split("\n").collect::<Vec<&str>>();

    let a: isize = lines[0].split(" ").last().unwrap().parse().unwrap();
    let b: isize = lines[1].split(" ").last().unwrap().parse().unwrap();
    let c: isize = lines[2].split(" ").last().unwrap().parse().unwrap();

    let program: Vec<u8> = lines[4]
        .split_once("Program: ")
        .unwrap()
        .1
        .split(",")
        .map(|x| x.parse().unwrap())
        .collect();

    let res = run_program(program, a, b, c);

    println!("Result: {}", res);
}

fn run_program(program: Vec<u8>, mut a: isize, mut b: isize, mut c: isize) -> String {
    let mut instruction_pointer = 0;

    let mut res = "".to_string();
    while instruction_pointer < program.len() - 1 {
        let opcoode = program[instruction_pointer];
        let operand = program[instruction_pointer + 1];
        let combo_operand = match operand {
            0 | 1 | 2 | 3 => operand as isize,
            4 => a,
            5 => b,
            6 => c,
            _ => panic!("Invalid operand"),
        };

        match opcoode {
            0 => {
                a = a / (2_isize.pow(combo_operand.try_into().unwrap()));
            }
            1 => {
                b = b ^ operand as isize;
            }
            2 => {
                b = combo_operand % 8;
            }
            3 if a != 0 && (instruction_pointer != (operand as usize)) => {
                instruction_pointer = operand as usize;
                continue;
            }
            3 => {}
            4 => {
                b = b ^ c;
            }
            5 => {
                let output = combo_operand % 8;
                res.push_str(&output.to_string());
                res.push(',');
            }
            6 => {
                b = a / (2_isize.pow(combo_operand.try_into().unwrap()));
            }
            7 => {
                c = a / (2_isize.pow(combo_operand.try_into().unwrap()));
            }
            _ => panic!("Invalid opcode"),
        }
        instruction_pointer += 2;
    }

    res.pop();
    res
}
