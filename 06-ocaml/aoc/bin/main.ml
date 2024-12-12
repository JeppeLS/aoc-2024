type direction = Up | Down | Left | Right

module CoordPair = struct
    type t = int * int
    let compare = compare
end

module VisitedTuple = struct
    type t = int * int * direction
    let compare = compare
end
module VisitedSet = Set.Make(VisitedTuple)

module CoordSet = Set.Make(CoordPair)

type solution =
    | Escaped of (int * int) list
    | Looped of (int * int) list

let visited_set_to_list s =
    VisitedSet.to_list s
    |> List.map (fun (i, j, _) -> (i, j))
    |> CoordSet.of_list
    |> CoordSet.to_list

let add_to_map map i j =
    let row = List.nth map i in
    let new_row = List.mapi (fun col c -> if col = j then '#' else c) row in
    List.mapi (fun row_index r -> if row_index = i then new_row else r) map

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

    let next_visited = match next_char with
    | Some '#' ->
        let new_direction = match direction with
        | Up -> Right
        | Down -> Left
        | Left -> Up
        | Right -> Down
        in
            Some(i, j, new_direction)
    | Some _ ->
            Some(next_i, next_j, direction)
    | None -> None
    in

    match next_visited with
    | Some(i, j, direction) when VisitedSet.mem (i, j, direction) visited -> Looped (visited_set_to_list visited)
    | Some(i, j, direction) ->
        let new_visited = VisitedSet.add (i, j, direction) visited in
        step i j new_visited map direction height width
    | None -> Escaped (visited_set_to_list visited)

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
    let map = read_text_from_file "input.txt"
    |> String.split_on_char '\n'
    |> List.filter (fun s -> String.length s > 0)
    |> List.map string_to_char_list in

    let (start_row, start_col, direction) = find_start map in
    let initial_visited = VisitedSet.singleton (start_row, start_col, direction) in

    let height = List.length map in
    let width = List.length (List.hd map) in

    let visited = match step start_row start_col initial_visited map direction height width with
        | Escaped path -> path
        | Looped _ -> failwith "Original input looped" in

    print_endline "Part 1: ";
    print_int (List.length visited);
    print_newline ();

    let res = visited
        |> List.map (fun (i, j) -> add_to_map map i j)
        |> List.map (fun map -> step start_row start_col initial_visited map direction height width)
        |> List.fold_left (fun acc x ->
            match x with
            | Escaped _ -> acc
            | Looped _ ->
                    acc + 1
            ) 0
    in

    print_endline "Part 2: ";
    print_int res;
    print_newline ()

