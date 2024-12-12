function read_input(path: string): string {
    return Deno.readTextFileSync(path);
}

export function add(a: number, b: number): number {
    return a + b;
}

function build_disk(input: string): (string | number)[] {
    // iterate over input
    const res = [];
    for (let i = 0; i < input.length; i++) {
        const is_even = i % 2 === 0;
        const idx = i / 2;
        const amount = parseInt(input[i]);

        for (let j = 0; j < amount; j++) {
            if (is_even) {
                res.push(idx);
            } else {
                res.push(".");
            }
        }
    }
    return res;
}

function sort_disk(disk: (string | number)[]): (string | number)[] {
    let start = 0;
    let end = disk.length - 1;

    while (start < end) {
        const end_char = disk[end];
        if (end_char === ".") {
            end--;
            continue;
        }
        const start_char = disk[start];
        if (start_char !== ".") {
            start++;
            continue;
        }
        disk[start] = end_char;
        disk[end] = ".";
        start++;
        end--;
    }

    return disk;
}

function calculate_checksum(disk: (string | number)[]): number {
    let sum = 0;
    for (let i = 0; i < disk.length; i++) {
        const value = disk[i];
        if (typeof value === "string") {
            break;
        }
        sum = sum + i * value;
    }
    return sum;
}

if (import.meta.main) {
    const input = read_input("input.txt");
    const disk = build_disk(input);
    const sorted = sort_disk(disk);
    const checksum = calculate_checksum(sorted);
    console.log(checksum);
}
