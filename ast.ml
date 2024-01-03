module Syntax = struct

  type type_t =
    | Bool_t
    | Int_t
    | Func_t of type_t * type_t list

  type expr =
    | Int of { value: int
             ; pos: Lexing.position }
    | String of { value: string
             ; pos: Lexing.position }
    | Bool of { value: bool
             ; pos: Lexing.position }
    | Call of { func: string ; args: expr list
             ; pos: Lexing.position }


  type instr=
    | Decl   of {var  : string; pos: Lexing.position }
    | Assign of {var  : string; expr: expr; pos: Lexing.position}
    | Return of {expr : expr; pos: Lexing.position}
    | Print  of {args : expr list; pos : Lexing.position}
    | Cond   of {cond : expr; then_block : block; else_block: block; pos : Lexing.position}
    | Loop   of {cond : expr; block: block; pos : Lexing.position}
    (* | Scan   of {var  : string; pos : Lexing.position} *)
    (* | Func   of *)

  and block = instr list
end


module IR = struct
  type expr =
    | Int    of int
    | String of string
    | Bool   of bool
    | Void
    | Call   of string * expr list

  type instr =
  | Decl   of string
  | Assign of string * expr
  | Return of expr
  | Print  of expr list
  | Cond   of expr * block * block
  | Loop   of expr * block
  (* | Scan   of string *)
  (* | Func   of string * expr list *)

  and block = instr list
end
