package org.example;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;

public class App {
    private HashMap<BlinkArgument, Long> cache = new HashMap<>();

    private record BlinkArgument(long stone, int amount) {
    };

    public void solve(String input) {
        long partOne = 0L;
        for (String stoneString : input.split(" ")) {
            Long stone = Long.parseLong(stoneString.strip());

            partOne += blink(stone, 75);
        }

        System.out.println(partOne);
    }

    private Long blink(Long stone, int amount) {
        Long cached = cache.get(new BlinkArgument(stone, amount));
        if (cached != null) {
            return cached;
        }

        if (amount == 0) {
            return 1L;
        }
        if (stone == 0) {
            long res = blink(1L, amount - 1);
            cache.put(new BlinkArgument(1L, amount - 1), res);
            return res;
        }

        int digets = (int) Math.ceil(Math.log10(stone + 1));
        if (digets % 2 == 0) {
            int half = digets / 2;
            long half10 = ((long) Math.pow(10, half));
            long first = stone / half10;
            long res1;
            BlinkArgument blink1 = new BlinkArgument(first, amount - 1);
            Long cached1 = cache.get(blink1);
            if (cached1 != null) {
                res1 = cached1;
            } else {
                res1 = blink(first, amount - 1);
                cache.put(blink1, res1);
            }

            long second = stone % half10;
            BlinkArgument blink2 = (new BlinkArgument(second, amount - 1));
            Long cached2 = cache.get(blink2);
            long res2;
            if (cached2 != null) {
                res2 = cached2;
            } else {
                res2 = blink(second, amount - 1);
                cache.put(new BlinkArgument(second, amount - 1), res2);
            }

            cache.put(new BlinkArgument(stone, amount), res1 + res2);
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
