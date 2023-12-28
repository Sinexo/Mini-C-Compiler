open Ast
open Ast.IR
open Baselib

exception Error of string * Lexing.position

let rec analyze_expr expr env =
  match expr with
  | Syntax.Int n -> Int n.value
  | Syntax.String s -> String s.value
  | Syntax.Bool b -> Bool b.value

let analyze parsed =
  analyze_expr parsed Baselib._types_

(* let rec analyze_instr instr env = *)
