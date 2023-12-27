%{
  open Ast
  open Ast.Syntax
%}

%token <int> Lint
%token <string> Lvar
%token <bool> Lbool
%token Lend

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
;
