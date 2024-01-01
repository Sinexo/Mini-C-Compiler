open Ast.IR
open Mips

module Env = Map.Make (String)

type cinfo = {
  asm: Mips.instr list;
  env: Mips.loc Env.t;
  fpo: int;
  data_decls: Mips.decl list; (* Ajout pour gérer les déclarations de données *)
}

let new_label =
  let counter = ref 0 in
  fun () ->
    incr counter;
    "str" ^ string_of_int !counter

    let rec compile_expr e env info =
      match e with
      | Int n -> ([Li (V0, n)], info)
      | Bool b -> ([Li (V0, if b then 1 else 0)], info)
      | String s ->
          let label = new_label () in
          let formattedString = String.sub s 1 (String.length s - 2) in
          let new_info = { info with data_decls = info.data_decls @ [(label, Mips.Asciiz formattedString)] } in
          ([La (A0, Lbl label)], new_info)
      | Call (f, args) ->
          let new_asm, new_info =
            List.fold_right
              (fun a (acc_asm, acc_info) ->
                let instrs, info = compile_expr a env acc_info in
                (instrs @ [Addi (SP, SP, -4); Sw (V0, Mem (SP, 0))] @ acc_asm, info))
              args ([], info)
          in
          (new_asm @ [Jal f; Addi (SP, SP, 4 * List.length args)], new_info)
      | Void -> ([], info)

    let rec compile_instr instr info =
      match instr with
      | Decl v ->{
            info with
            fpo = info.fpo - 4;
            env = Env.add v (Mem (FP, info.fpo)) info.env;
          }
      | Assign (v, e) ->
          let compiled_expr, new_info = compile_expr e info.env info in{
            new_info with
            asm = new_info.asm @ compiled_expr @ [Sw (V0, Env.find v new_info.env)];  (* Modification ici *)
          }
      | Return e ->
          let compiled_expr, new_info = compile_expr e info.env info in
          { new_info with asm = new_info.asm @ compiled_expr @ [Move (SP, FP); Jr RA] }
      | Print p ->
            let new_info, compiled_prints = List.fold_right (fun e (acc_info, acc_asm) ->
              let compiled_expr, new_info = compile_expr e acc_info.env acc_info in
              (new_info, acc_asm @ compiled_expr @ match e with
                | Int n -> [Li (A0, n); Li (V0, Syscall.print_int); Syscall]
                | String _ -> [Li (V0, Syscall.print_str); Syscall]
                | _ -> [])
            ) p (info, [])
            in
            { new_info with asm = info.asm @ compiled_prints }
        
        
        

      
      (* ... autres cas, comme Cond et Loop ... *)
    


and compile_block block info =
  match block with
  | i :: b ->
      let new_info = compile_instr i info in
      compile_block b new_info
  | [] -> info

let compile ir =
  let init_info = {
    asm = Baselib.builtins;
    env = Env.empty;
    fpo = 0;
    data_decls = [];
  } in
  let compiled = compile_block ir init_info in
  { text = Move (FP, SP) :: Addi (FP, SP, compiled.fpo) :: compiled.asm; data = List.rev compiled.data_decls }
