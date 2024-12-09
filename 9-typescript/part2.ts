function read_input(path: string): string {
    return Deno.readTextFileSync(path);
}

export function add(a: number, b: number): number {
    return a + b;
}

interface Disk {
    free: FreeSpace[];
    used: UsedSpace[];
}

interface FreeSpace {
    start: number;
    amount: number;
}

interface UsedSpace {
    start: number;
    amount: number;
    id: number;
}

function build_disk(input: string): Disk {
    const free = [];
    const used = [];
    let idx = 0;
    let id = 0;
    for (let i = 0; i < input.length; i++) {
        const is_even = i % 2 === 0;
        const amount = parseInt(input[i]);

        if (is_even) {
            used.push({ start: idx, amount, id: id });
            id += 1;
        } else {
            free.push({ start: idx, amount });
        }
        idx += amount;
    }
    return { free, used };
}

function sort_disk(disk: Disk): Disk {
    const used = disk.used.reverse();
    const new_used = [];
    for (const u of used) {
        let added = false;
        for (let i = 0; i < disk.free.length; i++) {
            const f = disk.free[i];
            if (u.start < f.start) {
                break;
            }
            if (u.amount > f.amount) {
                continue;
            }
            const difference = f.amount - u.amount;
            new_used.push({
                start: f.start,
                amount: u.amount,
                id: u.id,
            });
            added = true;
            disk.free[i] = { start: f.start + u.amount, amount: difference };
            break;
        }
        if (!added) {
            new_used.push(u);
        }
    }
    return { free: disk.free, used: new_used };
}

function calculate_checksum(disk: Disk): number {
    let sum = 0;
    for (const used of disk.used) {
        const id = used.id;
        for (let i = used.start; i < used.start + used.amount; i++) {
            sum += id * i;
        }
    }

    return sum;
}

if (import.meta.main) {
    const input = read_input("input.txt");
    // const input = "2333133121414131402";
    const disk = build_disk(input);
    const sorted = sort_disk(disk);
    const checksum = calculate_checksum(sorted);
    console.log(checksum);
}
