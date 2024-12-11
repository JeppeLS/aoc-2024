package org.example;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class App {
    public void solve(String input) {
        long partOne = 0L;
        for (String stoneString : input.split(" ")) {
            Long stone = Long.parseLong(stoneString.strip());

            partOne += blink(stone, 25);
        }

        System.out.println(partOne);
    }

    private Long blink(Long stone, int amount) {
        if (amount == 0) {
            return 1L;
        }
        if (stone == 0) {
            return blink(1L, amount - 1);
        }

        int digets = (int) Math.ceil(Math.log10(stone + 1));
        if (digets % 2 == 0) {
            int half = digets / 2;
            long half10 = ((long) Math.pow(10, half));
            long first = stone / half10;
            long res1 = blink(first, amount - 1);

            long second = stone % half10;
            long res2 = blink(second, amount - 1);

            return res1 + res2;
        }

        return blink(stone * 2024, amount - 1);
    }

    public static void main(String[] args) throws IOException {
        String input = new String(Files.readAllBytes(Paths.get("input.txt")));
        App app = new App();
        app.solve(input);
    }
}
