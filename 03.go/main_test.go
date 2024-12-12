package main

import (
	"testing"
)

func TestPartTwo(t *testing.T) {
	input := `mul(1,2)ash234do()mul(3,4)don't()mul(100,100)34do()mul(1,2)`
	res := part_two(input)
	if res != 1*2+3*4+1*2 {
		t.Errorf("Expected 1*2+3*4+1*2 = 16 got %d", res)
	}
}
