open Ast.IR
open Mips

module Env = Map.Make(String)

type cinfo = { code: Mips.instr list
             ; env: Mips.loc Env.t
             ; fpo: int
             ; counter: int
             ; return: string }

let rec compile_expr e env=
  match e with
  | Int n  -> [ Li (V0, n) ]
  | Bool b -> [ Li (V0, if b then 1 else 0)]
  | String s -> [ Lw (V0,Env.find s env s) ]
  | Void    -> [ Li (V0, 0) ]


let compile ir =
  { text = Baselib.builtins @ compile_expr ir Env.empty
  ; data = [] }
