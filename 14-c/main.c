#include <stdio.h>
#include <stdlib.h>

#define MAX_LINES 500
#define VALUES_PER_LINE 4

int main() {

    // Open the file for reading
    FILE *file = fopen("input.txt", "r");
    if (file == NULL) {
        perror("Error opening file");
        return EXIT_FAILURE;
    }

    // Read the file line by line
    char line[256];
    int robots[MAX_LINES][VALUES_PER_LINE];
    int lineCount = 0;
    while (fgets(line, sizeof(line), file)) {
        if (lineCount >= MAX_LINES) {
            fprintf(stderr, "Error: Too many lines in the file.\n");
            break;
        }

        // Parse the line into integers
        if (sscanf(line, "p=%d,%d v=%d,%d",
                   &robots[lineCount][0], &robots[lineCount][1],
                   &robots[lineCount][2], &robots[lineCount][3]) != 4) {
            fprintf(stderr, "Error: Invalid format on line %d.\n", lineCount + 1);
            continue;
        }

        lineCount++;
    }

    fclose(file);

    int width = 101;
    int height = 103;
    int seconds = 100;
    int q1 = 0;
    int q2 = 0;
    int q3 = 0;
    int q4 = 0;
    int middleRow = height / 2;
    int middleCol = width / 2;
    for (int i = 0; i < lineCount; i++) {
        int *robot = robots[i];
        int col = robot[0];
        int row = robot[1];
        int colSpeed = robot[2];
        int rowSpeed = robot[3];

        int endRow = (row + rowSpeed * seconds) % height;
        if (endRow < 0) {
            endRow += height;
        }
        int endCol = (col + colSpeed * seconds) % width;
        if (endCol < 0) {
            endCol += width;
        }

        if (endRow < middleRow && endCol < middleCol) {
            q1++;
        } else if (endRow < middleRow && endCol > middleCol) {
            q2++;
        } else if (endRow > middleRow && endCol < middleCol) {
            q3++;
        } else if (endRow > middleRow && endCol > middleCol) {
            q4++;
        }

    }

    int result = q1 * q2 * q3 * q4;

    printf("Result: %d\n", result);

    return EXIT_SUCCESS;
}
