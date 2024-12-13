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

    val result = machines.map(solve).fold(0)((a, b) => a + b)

    println(result)
  }

  def solve(machine: Machine): Int = {
    var best: Integer = null
    for (a <- 0 to 100) {
      for (b <- 0 to 100) {
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
    x: Int,
    y: Int
)

case class Button(
    x: Int,
    y: Int
)
