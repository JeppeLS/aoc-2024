defmodule Aoc do
  @moduledoc """
  Documentation for `Aoc`.

  This is my first Elixir project.
  I'm trying to solve the Advent of Code 2024 day 4 challenge and experiment
  with Elixir.
  """

  def start(_type, _args) do
    input = File.read!("input.txt")

    xmas_matches = Aoc.count_xmas_matches(input)
    cross_matches = Aoc.count_cross_mas_matches(input)

    IO.puts("There are #{xmas_matches} matches")
    IO.puts("There are #{cross_matches} cross matches")

    {:ok, self()}
  end

  @doc """
  Count the number of matches of the word XMAS in the given string.

  A match can either be vertical, horizontal, or diagonal. And can be both backwards and forwards.

  ## Examples

      iex> Aoc.count_xmas_matches("XMAS")
      1

  """
  def count_xmas_matches(string) do
    lines =
      string
      |> String.split("\n", trim: true)

    non_horizontal_matches =
      lines
      |> Enum.chunk_every(4, 1, :discard)
      |> Enum.reduce(0, fn [a, b, c, d], acc ->
        matches =
          0..(String.length(a) - 1)
          |> Enum.reduce(0, fn index, acc ->
            vertical =
              [a, b, c, d]
              |> Enum.map(fn x -> String.at(x, index) end)
              |> Enum.join()

            diagonal1 =
              [a, b, c, d]
              |> Enum.with_index()
              |> Enum.map(fn {str, n} -> String.at(str, index + n) end)
              |> Enum.join()

            diagonal2 =
              [a, b, c, d]
              |> Enum.with_index()
              |> Enum.map(fn {str, n} -> String.at(str, index + 3 - n) end)
              |> Enum.join()

            matches =
              [vertical, diagonal1, diagonal2]
              |> Enum.filter(fn str -> str in ["XMAS", "SAMX"] end)
              |> length()

            acc + matches
          end)

        acc + matches
      end)

    horizontal_matches =
      lines
      |> Enum.reduce(0, fn line, acc ->
        matches =
          0..(String.length(line) - 4)
          |> Enum.reduce(0, fn index, acc ->
            case String.slice(line, index, 4) do
              word when word in ["XMAS", "SAMX"] -> acc + 1
              _ -> acc
            end
          end)

        acc + matches
      end)

    horizontal_matches + non_horizontal_matches
  end

  @doc """
  Count the number of MAS appearing in a cross shape
  """
  def count_cross_mas_matches(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.reduce(0, fn [a, b, c], acc ->
      matches =
        0..(String.length(a) - 3)
        |> Enum.reduce(0, fn index, acc ->
          diagonal1 =
            [a, b, c]
            |> Enum.with_index()
            |> Enum.map(fn {str, n} -> String.at(str, index + n) end)
            |> Enum.join()

          diagonal2 =
            [a, b, c]
            |> Enum.with_index()
            |> Enum.map(fn {str, n} -> String.at(str, index + 2 - n) end)
            |> Enum.join()

          case {diagonal1, diagonal2} do
            {d1, d2} when d1 in ["MAS", "SAM"] and d2 in ["MAS", "SAM"] -> acc + 1
            _ -> acc
          end
        end)

      acc + matches
    end)
  end
end
