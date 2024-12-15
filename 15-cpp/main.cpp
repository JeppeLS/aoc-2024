#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <sstream>

struct Cell {
    int row;
    int col;
};

struct Grid {
    std::vector<std::vector<char>> map;
    Cell robot;
};

int GpsCoord(Cell cell) {
    return 100 * cell.row + cell.col;
}

Cell nextCell(Cell cell, char command) {
    int newRow = cell.row;
    int newCol = cell.col;

    switch (command) {
        case '^':
            newRow--;
            break;
        case 'v':
            newRow++;
            break;
        case '<':
            newCol--;
            break;
        case '>':
            newCol++;
            break;
        default:
            throw std::runtime_error("Error: Invalid command.");
    }
    return {newRow, newCol};
}


Grid moveRobot(
    Grid grid,
    char command
) {

    auto map = grid.map;
    auto current = grid.robot;
    auto next = nextCell(current, command);


    bool outOfBounds = next.row < 0 ||
        next.row >= map.size() ||
        next.col < 0 ||
        next.col >= map[0].size();
    if (outOfBounds) {
        throw std::runtime_error("Error: Robot went out of bounds.");
    }

    if (map[next.row][next.col] == '#') {
        return grid;
    }

    if (map[next.row][next.col] == '.') {
        map[current.row][current.col] = '.';
        map[next.row][next.col] = '@';
        return Grid{map, next};
    }

    while (map[next.row][next.col] == 'O') {
        next = nextCell(next, command);
        if (map[next.row][next.col] == '#') {
            return grid;
        }
    }

    map[next.row][next.col] = 'O';
    map[current.row][current.col] = '.';
    next = nextCell(current, command);
    map[next.row][next.col] = '@';

    return Grid{map, next};
}

std::vector<Cell> findBoxes(std::vector<std::vector<char>> map) {
    std::vector<Cell> boxes;
    for (int i=0; i<map.size(); i++) {
        for (int j=0; j<map[i].size(); j++) {
            if (map[i][j] == 'O') {
                boxes.push_back({i, j});
            }
        }
    }
    return boxes;
}

int main() {
    std::ifstream file("input.txt");
    if (!file.is_open()) {
        std::cerr << "Error: Could not open the file." << std::endl;
        return 1;
    }

    std::vector<std::vector<char>> map;
    std::vector<char> commands;

    std::string line;
    bool parsingMap = true;
    while (std::getline(file, line)) {
        if (line.empty()) {
            parsingMap = false;
            continue;
        }

        if (parsingMap) {
            std::vector<char> row(line.begin(), line.end());
            map.push_back(row);
        } else {
            commands.insert(commands.end(), line.begin(), line.end());
        }
    }

    file.close();

    int robotRow = 0;
    int robotCol = 0;
    for (int i=0; i<map.size(); i++) {
        for (int j=0; j<map[i].size(); j++) {
            if (map[i][j] == '@') {
                robotRow = i;
                robotCol = j;
                break;
            }
        }
    }


    Grid grid{map, {robotRow, robotCol}};
    for (char command : commands) {
        grid = moveRobot(grid, command);
    }

    auto boxes = findBoxes(grid.map);
    int result = 0;
    for (auto box : boxes) {
        int gps = GpsCoord(box);
        result += gps;
    }


    std::cout << "Result: " << result << std::endl;
    return 0;
}

