import java.io.File

val input = File("input.txt")
val rules = HashMap<Int, MutableSet<Int>>()

var isRule = true
var validRes = 0
var invalidRes = 0
for (line in input.readLines()) {
    if (line == "") {
        isRule = false
        continue
    }

    if (isRule) {
        val (before, after) = line.split("|")
        val fromRules = rules.computeIfAbsent(before.toInt()) { HashSet() }
        fromRules.add(after.toInt())
        continue
    }

    val update = line.split(",").map { it.toInt() }

    val reordered = reorder(update, rules)

    val middle = reordered[reordered.size / 2]

    if (update == reordered) {
        validRes += middle
    } else {
        invalidRes += middle
    }
}

println(validRes)
println(invalidRes)

fun reorder(update: List<Int>, rules: Map<Int, Set<Int>>): List<Int> {
    for ((currentIdx, page) in update.withIndex()) {
        val rule = rules[page]
        if (rule == null) {
            continue
        }

        for ((idx, value) in update.subList(0, currentIdx).withIndex() ) {
            if (value !in rule) {
                continue
            }
            val swapped = update.swapIndices(idx, currentIdx)
            return reorder(swapped, rules)
        }
    }
    return update
}

fun <T> List<T>.swapIndices(index1: Int, index2: Int): List<T> {
    if (index1 == index2) return this
    if (index1 !in indices || index2 !in indices) {
        throw IndexOutOfBoundsException("Invalid indices: $index1, $index2")
    }

    val mutableList = this.toMutableList()
    mutableList[index1] = this[index2]
    mutableList[index2] = this[index1]
    return mutableList
}