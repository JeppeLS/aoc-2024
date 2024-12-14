#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

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

    int positions[lineCount][2];
    for (int i=0; i < lineCount; i++) {
        positions[i][0] = robots[i][1];
        positions[i][1] = robots[i][0];
    }
    bool map[height][width];

    for (int seconds=1; seconds < 100000; seconds++) {
        // Reset the map
        for (int h=0; h < height; h++) {
            for (int w=0; w < width; w++) {
                map[h][w] = false;
            }
        }

        // Move the robots
        bool collided = false;
        for (int i=0; i < lineCount; i++) {
            int *robot = robots[i];
            int *position = positions[i];
            int row = position[0];
            int col = position[1];
            int colSpeed = robot[2];
            int rowSpeed = robot[3];

            int endRow = (row + rowSpeed) % height;
            if (endRow < 0) {
                endRow += height;
            }
            int endCol = (col + colSpeed) % width;
            if (endCol < 0) {
                endCol += width;
            }

            positions[i][0] = endRow;
            positions[i][1] = endCol;

            if (map[endRow][endCol]) {
                collided = true;
            }
            map[endRow][endCol] = true;
        }

        if (!collided) {
            printf("Unique positions for everyone\n");

            // Print the map
            for (int w=-1; w < width; w++) {
                if (w == -1) {
                    printf("   ");
                } else {
                    printf("%d ", w / 10);
                }
            }
            printf("\n");
            for (int h=0; h < height; h++) {
                printf("%02d ", h);
                for (int w=0; w < width; w++) {
                    if (h == 0) {
                    }
                    if (map[h][w]) {
                        printf(" #");
                    } else {
                        printf(" .");
                    }
                }
                printf("\n");
            }
            printf("Seconds: %d\n", seconds);
            printf("Press Enter to continue...");
            getchar();
        }
    }
}
