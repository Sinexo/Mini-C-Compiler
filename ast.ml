module Syntax = struct
  type expr =
    | Int of { value: int
             ; pos: Lexing.position }
    | String of { value: string
             ; pos: Lexing.position }
    | Bool of { value: bool
             ; pos: Lexing.position }

  type instr=
    | Decl   of {var: string; pos: Lexing.position }
    | Assign of {var: string; expr: expr; pos: Lexing.position}

end


module IR = struct
  type expr =
    | Int of int
    | String of string
    | Bool of bool
    | Void
end
