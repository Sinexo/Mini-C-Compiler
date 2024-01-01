%{
  open Ast
  open Ast.Syntax
%}

%token <int> Lint
%token <bool> Lbool
%token <string> Lstring
%token <string> Lvar
%token Ladd Lsub Lmul Ldiv Lopen Lclose
%token Lreturn Lassign Lsc Lend Lprint Lscan Lvirgule

%left Ladd Lsub
%left Lmul Ldiv

%start prog

%type <Ast.Syntax.block> prog

%%
block:
| Lend { [] }
| i = instr; b = block { i @ b }
| i = instr; Lsc { i }
;

expr_list:
  | e = expr                            { [e] }
  | e = expr; Lvirgule; el = expr_list   { e :: el }
;

prog:
|i = instr; Lsc; b =  prog{i@b}
|i = instr; Lsc; Lend {i}
;

// prog:
// | b = block; Lend { b }
// ;

instr:
| Lvar; id = Lvar { [ Decl { var = id; pos = $startpos(id) } ] }

| Lvar; id = Lvar; Lassign; e = expr {
    [ Decl { var = id; pos = $startpos(id) };
      Assign { var = id; expr = e; pos = $startpos($3) } ]
}

| id = Lvar; Lassign; e = expr {
    [ Assign { var = id; expr = e; pos = $startpos($2) } ]
}


| Lprint; Lopen; e = expr_list; Lclose { 
	[Print { args = e; pos = $startpos }]
}

| Lreturn; e = expr {
	[Return { expr = e;pos = $startpos($1)}]
}

expr:
| n = Lint {
  Int { value = n; pos = $startpos(n) }
}

| s = Lstring {
  String { value = s; pos = $startpos(s) }
}

| b = Lbool {
  Bool { value = b; pos = $startpos(b) }
}

| Lopen; e = expr; Lclose
	{e}

| e = expr; Ladd; d = expr {
  Call { func = "_add"; args = [e; d]; pos = $startpos($2) }
}

| e = expr; Lsub; d = expr {
  Call { func = "_sub"; args = [e; d]; pos = $startpos($2) }
}

| e = expr; Lmul; d = expr {
  Call { func = "_mul"; args = [e; d]; pos = $startpos($2) }
}

| e = expr; Ldiv; d = expr {
  Call { func = "_div"; args = [e; d]; pos = $startpos($2) }
};
