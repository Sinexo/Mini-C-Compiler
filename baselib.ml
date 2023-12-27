
open Ast
open Ast.Syntax
open Mips

module Env = Map.Make(String)

let _types_ = Env.empty

let builtins =[]
