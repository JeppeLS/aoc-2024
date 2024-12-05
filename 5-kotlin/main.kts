import java.io.File

val input = File("input.txt")
val rules = HashMap<Int, MutableSet<Int>>()

var isRule = true
var res = 0
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
    if (!isValid(update, rules)) {
        continue
    }
    val middle = update[update.size / 2]
    res += middle
}

println(res)

fun isValid(update: List<Int>, rules: Map<Int, Set<Int>>): Boolean {
    val before = ArrayList<Int>()
    for (page in update) {
        val rule = rules[page]
        if (rule == null) {
            before.add(page)
            continue
        }

        if (before.any { it in rule} ) {
            return false
        }
        before.add(page)
    }
    return true
}
