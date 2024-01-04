{
  open Parser

  exception Error of char
}

let num = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let identifier = alpha (alpha | num | '-' | '_')*

rule token = parse
| eof             { Lend }
| [ ' ' '\t' ]    { token lexbuf }
| '\n'            { Lexing.new_line lexbuf; token lexbuf }
| "//"            { comment lexbuf }
| '"'[^'"']*'"'   { Lstring (Lexing.lexeme lexbuf) }
| "true"		  { Lbool true }
| "false"		  { Lbool false }
| ";"			  { Lsc }
| ","             { Lvirgule }
| "("			  { Lopen }
| ")"			  { Lclose }
| "{" 			  { Laccopen }
| "}"			  { Laccclose }
| "*"			  { Lmul }
| "/"			  { Ldiv }
| "%"             {LdivE}
| "="			  { Lassign }
| "+"			  { Ladd }
| "<"			  { Llt }
| ">"			  { Lgt }
| "<="			  { Llte }
| ">="			  { Lgte }
| "=="			  {	Lequal }
| "!="		  	  { Lnequal }
| "!"			  { Lnot }
| "&&"			  { Land }
| "||"			  { Lor }
| "if"			  { Lif }
| "else"		  { Lelse }
| "while"		  { Lwhile }
| ";"			  { Lsc }
(* | "func"		  { Lfunc } *)
| "return"		  { Lreturn }
| "print"		  { Lprint }
(* | "%d"			{LdInt} *)
(*| "%s"{LdString} *)
(* | "scan"		  { Lscan } *)
| num+ as n       { Lint (int_of_string n) }
(* | alpha+ as v	  { Lstring v } *)
| identifier+ as id { Lvar (id) }
| _ as c          { raise (Error c) }


and comment = parse
| eof  { Lend }
| '\n' { Lexing.new_line lexbuf; token lexbuf }
| _    { comment lexbuf }