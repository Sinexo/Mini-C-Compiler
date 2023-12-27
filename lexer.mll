{
  open Lexing
  open Parser

  exception Error of char
}

let num = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']

rule token = parse
| eof             { Lend }
| [ ' ' '\t' ]    { token lexbuf }
| '\n'            { Lexing.new_line lexbuf; token lexbuf }
| "/"          	  { comment lexbuf }
| "true"		  { Lbool true }
| "false"		  { Lbool false }
| num+ as n       { Lint (int_of_string n) }
| alpha+ as v	  { Lvar v }
| _ as c          { raise (Error c) }
| ";" { Lend }

and comment = parse
| eof  { Lend }
| '\n' { Lexing.new_line lexbuf; token lexbuf }
| _    { comment lexbuf }