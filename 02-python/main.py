import unittest


def main():
    safe = 0
    safe_with_single_replacement = 0
    with open("input.txt") as f:
        for line in f:
            numbers = [int(x) for x in line.split(" ")]
            if is_safe(numbers):
                safe += 1
            if is_safe_with_single_remove(numbers):
                safe_with_single_replacement += 1
    print(safe)

    print(safe_with_single_replacement)


def is_safe(numbers: list[int]) -> bool:
    if len(numbers) == 0:
        return False

    if len(numbers) == 1:
        return True

    prev = numbers[0]
    increasing = None
    for current in numbers[1:]:
        if prev == current:
            return False
        if abs(prev - current) > 3:
            return False
        if increasing is None:
            increasing = prev < current
        elif increasing != (prev < current):
            return False
        prev = current
    return True


def is_safe_with_single_remove(numbers: list[int]) -> bool:
    if is_safe(numbers):
        return True

    for i in range(len(numbers)):
        sliced = numbers[:i] + numbers[i + 1 :]
        if is_safe(sliced):
            return True
    return False


class TestIsSafe(unittest.TestCase):
    def test_is_safe(self):
        examples = [
            ([7, 6, 4, 2, 1], True),
            ([1, 2, 7, 8, 9], False),
            ([9, 7, 6, 2, 1], False),
            ([1, 3, 2, 4, 5], False),
            ([8, 6, 4, 4, 1], False),
            ([1, 3, 6, 7, 9], True),
        ]

        for numbers, expected in examples:
            self.assertEqual(is_safe(numbers), expected, f"Failing for {numbers}")

    def test_is_safe_with_single_remove(self):
        examples = [
            ([7, 6, 4, 2, 1], True),
            ([1, 2, 7, 8, 9], False),
            ([9, 7, 6, 2, 1], False),
            ([1, 3, 2, 4, 5], True),
            ([8, 6, 4, 4, 1], True),
            ([1, 3, 6, 7, 9], True),
        ]

        for numbers, expected in examples:
            self.assertEqual(
                is_safe_with_single_remove(numbers), expected, f"Failing for {numbers}"
            )


if __name__ == "__main__":
    main()
