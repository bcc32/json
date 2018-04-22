open! Core

include Json0

let of_string input =
  input
  |> Lexing.from_string
  |> Parser.json Lexer.token
;;
