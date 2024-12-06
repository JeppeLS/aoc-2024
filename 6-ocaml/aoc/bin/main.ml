module StringMap = Map.Make(String)
module Visited = Set.Make(struct
    type t = int * int
    let compare = compare
end)

type direction = Up | Down | Left | Right

let read_text_from_file filename =
  try
    In_channel.with_open_text
      filename
      In_channel.input_all
  with Sys_error msg ->
    failwith ("Failed to read from file: " ^ msg)

let string_to_char_list s =
    String.to_seq s |> List.of_seq

let rec step = fun i j visited map direction height width ->
    let (next_i, next_j) = match direction with
    | Up -> (i - 1, j)
    | Down -> (i + 1, j)
    | Left -> (i, j - 1)
    | Right -> (i, j + 1)
    in

    let next_char = match (next_i, next_j) with
    | (i, j) when i < 0 || i >= height || j < 0 || j >= width -> None
    | (i, j) ->
            let row = List.nth map i in
            Some (List.nth row j)
    in

    match next_char with
    | Some '#' ->
        let new_direction = match direction with
        | Up -> Right
        | Down -> Left
        | Left -> Up
        | Right -> Down
        in
        step i j visited map new_direction height width
    | Some _ ->
        let new_visited = Visited.add (next_i, next_j) visited in
        step next_i next_j new_visited map direction height width
    | None -> visited

let rec find_start_col row j =
    match row with
    | [] -> None
    | '^' :: _ ->  Some (j, Up)
    | 'v' :: _ ->  Some (j, Down)
    | '<' :: _ ->  Some (j, Left)
    | '>' :: _ ->  Some (j, Right)
    | _ :: rest -> find_start_col rest (j + 1)

let rec find_start_row lines i =
    match lines with
    | [] -> failwith "No start found"
    | row :: rest ->
        match find_start_col row 0 with
        | Some (j, direction) -> Some(i, j, direction)
        | None -> find_start_row rest (i + 1)

let find_start lines =
    match find_start_row lines 0 with
    | Some start -> start
    | None -> failwith "No start found"

let () =
    let lines = read_text_from_file "input.txt"
    |> String.split_on_char '\n'
    |> List.filter (fun s -> String.length s > 0)
    |> List.map string_to_char_list in

    let (i, j, direction) = find_start lines in
    let initial_visited = Visited.singleton (i, j) in

    let height = List.length lines in
    let width = List.length (List.hd lines) in

    let visited = step i j initial_visited lines direction height width in

    print_endline (string_of_int (Visited.cardinal visited));
