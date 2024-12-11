package org.example;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;

public class App {
    public void solve(String input) {
        ArrayList<Long> stones = new ArrayList<>();
        for (String stone : input.split(" ")) {
            stones.add(Long.parseLong(stone.strip()));
        }

        for (int i = 0; i < 25; i++) {
            stones = blink(stones);
        }

        System.out.println(stones.size());
    }

    private ArrayList<Long> blink(ArrayList<Long> stones) {
        ArrayList<Long> res = new ArrayList<>();
        for (Long stone : stones) {
            if (stone == 0) {
                res.add(1L);
                continue;
            }

            String asString = stone.toString();
            int length = asString.length();
            if (length % 2 == 0) {
                int half = length / 2;
                long first = Long.parseLong(asString.substring(0, half));
                long second = Long.parseLong(asString.substring(half, length));
                res.add(first);
                res.add(second);
                continue;
            }

            res.add(stone * 2024);
        }
        return res;
    }

    public static void main(String[] args) throws IOException {
        String input = new String(Files.readAllBytes(Paths.get("input.txt")));
        App app = new App();
        app.solve(input);
    }
}
