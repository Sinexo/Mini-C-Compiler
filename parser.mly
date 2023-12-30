%{
  open Ast
  open Ast.Syntax
%}

%token <int> Lint
%token <bool> Lbool
%token <string> Lvar
%token Ladd Lsub Lmul Ldiv Lopar Lcpar
%token Lreturn Lassign Lsc Lend

%left Ladd Lsub
%left Lmul Ldiv

%start prog

%type <Ast.Syntax.expr> prog

%%

prog:
| e = expr; Lend { e }
;

expr:
| n = Lint {
  Int { value = n ; pos = $startpos(n) }
}
| s = Lvar {
  String { value = s; pos = $startpos(s)}
}
| b = Lbool {
  Bool {value = b; pos = $startpos(b)}
}

|e = expr; Ladd; d = expr{
	Call {func = "%add"; args=[e;d]; pos = $startpos}
}
|v =  Lvar {
	Var {name = v; pos = $startpos}
}
;
