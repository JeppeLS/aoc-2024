package main

import (
	_ "embed"
	"fmt"
	"regexp"
	"strconv"
)

//go:embed input.txt
var input string

func main() {
	re := regexp.MustCompile(`mul\((\d+),(\d+)\)`)

	matches := re.FindAllStringSubmatch(input, -1)

	res := 0
	for _, match := range matches {
		first, _ := strconv.Atoi(match[1])
		second, _ := strconv.Atoi(match[2])
		res += first * second
	}

	fmt.Println(res)
}
