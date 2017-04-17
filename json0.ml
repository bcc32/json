open Core

type t =
  | Null
  | Bool of bool
  | Number of float
  | String of string
  | Array of t list
  | Object of (string * t) list
[@@deriving sexp]
;;
