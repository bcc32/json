{
open Core
open Parser

let unescape input =
  let buf = Buffer.create (String.length input) in
  let rec loop i =
    if i = String.length input
    then (
      Buffer.contents buf
    )
    else if i > String.length input
    then (
      failwith "invalid string literal"
    )
    else if input.[i] = '\\'
    then (
      let (char, n) =
        match input.[i + 1] with
        | '"' -> '"', 1
        | '\\' -> '\\', 1
        | '/' -> '/', 1
        | 'b' -> '\b', 1
        | 'f' -> '\012', 1
        | 'n' -> '\n', 1
        | 'r' -> '\r', 1
        | 't' -> '\t', 1
        | 'u' -> failwith "unicode escapes unsupported" (* TODO *)
        | _ -> failwith "invalid escape sequence"
      in
      Buffer.add_char buf char;
      loop (i + n)
    )
    else (
      Buffer.add_char buf input.[i];
      loop (i + 1)
    )
  in
  loop 0
}

(* Numbers *)

let digit = ['0'-'9']

let number =
  '-'?
  ('0' | ['1'-'9'] digit*)
  ('.' digit*)?
  (['e''E'] ['+''-']? digit+)?

(* Strings *)

let escape = '\\'

let normal_char =
  [ ^
  '\x00'-'\x1f' (* control characters *)
  '"'
  '\\'
  ]

let hex_digit = [ '0'-'9' 'a'-'f' 'A'-'F' ]

let string_char =
  normal_char
  | escape [ '"' '\\' '/' 'b' 'f' 'n' 'r' 't' ]
  | escape 'u' hex_digit hex_digit hex_digit hex_digit

rule token = parse
  | number as lxm { NUMBER (Float.of_string lxm) }
  | '"' (string_char* as lxm) '"' { STRING (unescape lxm) }
  | "true" { TRUE }
  | "false" { FALSE }
  | "null" { NULL }
  | '[' { LARRAY }
  | ']' { RARRAY }
  | '{' { LOBJECT }
  | '}' { ROBJECT }
  | ',' { COMMA }
  | ':' { COLON }
  | [ ' ' '\n' '\r' '\t' ] { token lexbuf }
  | eof { EOF }
