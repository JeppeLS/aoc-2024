package main

import (
	_ "embed"
	"fmt"
	"regexp"
	"strconv"
)

//go:embed input.txt
var input string

func part_one(input string) int {
	re := regexp.MustCompile(`mul\((\d+),(\d+)\)`)

	matches := re.FindAllStringSubmatch(input, -1)

	res := 0
	for _, match := range matches {
		first, _ := strconv.Atoi(match[1])
		second, _ := strconv.Atoi(match[2])
		res += first * second
	}
	return res
}

func part_two(input string) int {
	inactive := regexp.MustCompile(`don't\(\)`)
	active := regexp.MustCompile(`do\(\)`)

	is_active := true
	idx := 0
	res := 0
	for idx < len(input) {
		if !is_active {
			start := active.FindStringIndex(input[idx:])
			if start == nil {
				break
			}
			idx += start[1]
			is_active = true
		}

		end := inactive.FindStringIndex(input[idx:])
		if end == nil {
			res += part_one(input[idx:])
			break
		} else {
			res += part_one(input[idx : idx+end[0]])
		}
		is_active = false
		idx += end[1]
	}

	return res
}

func main() {
	res1 := part_one(input)
	fmt.Println(res1)

	res2 := part_two(input)
	fmt.Println(res2)
}
