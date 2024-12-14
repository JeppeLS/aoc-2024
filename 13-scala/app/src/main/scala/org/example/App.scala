package org.example

object App {
  def main(args: Array[String]): Unit = {
    val source = scala.io.Source.fromFile("input.txt")
    val input =
      try source.mkString
      finally source.close()

    val machines = input
      .split("\n\n")
      .map(parseMachine)

    val part1 = machines.map(solve).fold(0L)((a, b) => a + b)

    val part2 = machines
      .map(fixPrice)
      .map(solveMachineAlgebrachically)
      .fold(0L)((a, b) => a + b)

    println("Part 1: " + part1)
    println("Part 2: " + part2)
  }

  def solve(machine: Machine): Long = {
    var best: java.lang.Long = null
    for (a <- 0L to 100L) {
      for (b <- 0L to 100L) {
        val x = machine.a.x * a + b * machine.b.x
        val y = machine.a.y * a + b * machine.b.y
        val isSolution = x == machine.prize.x && y == machine.prize.y

        val prize = a * 3 + b
        val isBetter = best == null || prize < best

        if (isSolution && isBetter) {
          best = prize
        }
      }
    }
    if (best == null) {
      return 0
    } else {
      return best
    }
  }

  def solveMachineAlgebrachically(machine: Machine): Long = {
    val b_num = machine.prize.x * machine.a.y - machine.a.x * machine.prize.y
    val b_denom = machine.b.x * machine.a.y - machine.a.x * machine.b.y
    if (b_num % b_denom != 0) {
      return 0
    }
    val b = b_num / b_denom

    val a_num = machine.prize.y - machine.b.y * b
    val a_denom = machine.a.y
    if (a_num % a_denom != 0) {
      return 0
    }
    val a = a_num / a_denom

    return 3 * a + b
  }

  def fixPrice(machine: Machine): Machine = {
    return Machine(
      machine.a,
      machine.b,
      Location(
        machine.prize.x + 10000000000000L,
        machine.prize.y + 10000000000000L
      )
    )
  }

  def parseMachine(machine: String): Machine = {
    val lines = machine.split("\n")
    val buttonAVals = parseLine(lines(0))
    val buttonBVals = parseLine(lines(1))
    val prizeLocation = parseLine(lines(2))

    return Machine(
      Button(buttonAVals(0), buttonAVals(1)),
      Button(buttonBVals(0), buttonBVals(1)),
      Location(prizeLocation(0), prizeLocation(1))
    )
  }

  def parseLine(line: String): Array[Int] = {
    return line.split(": ").last.split(", ").map(i => i.substring(2).toInt)
  }
}

case class Machine(
    a: Button,
    b: Button,
    prize: Location
)

case class Location(
    x: Long,
    y: Long
)

case class Button(
    x: Long,
    y: Long
)
