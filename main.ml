open! Core

let main () =
  let input = In_channel.(input_all stdin) in
  input
  |> Json.of_string
  |> printf !"%{sexp: Json.t}\n"
;;

let () = main ()
