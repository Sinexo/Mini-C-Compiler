open Ast.IR
open Mips

module Env = Map.Make(String)

(* Define the cinfo structure with additional label counter *)
type cinfo = {
  code: Mips.instr list;
  env: Mips.loc Env.t;
  fpo: int;
  counter: int;
  return: string;
  labelCounter: int; (* Added label counter *)
}

let string_count = ref 0

let newLabel prefix =
  incr string_count;
  Printf.sprintf "%s%d" prefix !string_count

let compileString s =
    let label = newLabel "str" in
    let formattedString = String.sub s 1 (String.length s - 2) in 
    [ La (A0, Lbl label) ], (label, Asciiz formattedString)

(* Updated compile_expr to handle strings with the new approach *)
let rec compile_expr e env =
  match e with
  | Int n  -> [ Li (V0, n) ], []
  | Bool b -> let value = if b then 1 else 0 in
              [ Li (V0, value) ], []
  | String s ->
    let instrs, dataDecl = compileString s in
    instrs, [dataDecl]
  | Void    -> [ Li (V0, 0) ], []

(* Updated compile function to handle the new structure of compile_expr *)
let compile ir =
  let exprs, dataDecls = List.fold_left (fun (exprsAcc, dataAcc) expr ->
    let instrs, dataDecl = compile_expr expr Env.empty in
    (instrs @ exprsAcc, dataDecl @ dataAcc)
  ) ([], []) [ir] in
  { text =List.rev exprs ; data = List.rev dataDecls
  }

