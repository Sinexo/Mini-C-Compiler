%{
  open Ast
  open Ast.Syntax
%}

%token <int> Lint
%token <bool> Lbool
%token <string> Lstring
%token <string> Lvar
%token Ladd Lsub Lmul Ldiv Lopen Lclose Lequal Lnequal
%token Lreturn Lassign Lsc Lend Lprint (*Linput*) Lvirgule
%token Lif Lelse Lwhile Laccopen Laccclose

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

// | Lscan;Lopen; e=expr; Lclose{
// 	e
// }

| Lreturn; e = expr {
	[Return { expr = e;pos = $startpos($1)}]
}

| Lif; Lopen ; c = expr; Lclose ; Laccopen ; t= block ; Laccclose ; Lelse ; Laccopen; e = block ; Laccclose ; {
	[Cond {cond = c; then_block = t; else_block = e; pos= $startpos(c)}]
}

| Lif; Lopen ; e = expr ; Lclose ; Laccopen ; b = block; Laccclose {
    [Cond { cond = e; then_block = b; else_block = []; pos = $startpos }]
}

| Lwhile; Lopen ; l = expr ; Lclose ; Laccopen; b = block ; Laccclose ;{
	[Loop { cond = l; block = b; pos = $startpos(l)}]
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

| id = Lvar {
	String { value = id;pos = $startpos(id)}
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
}

| e = expr; Lequal; d = expr {
  Call { func = "_eq"; args = [e;d]; pos = $startpos($2) }
}

| e = expr; Lnequal; d = expr {
  Call { func = "_neq"; args = [e;d]; pos = $startpos($2)}
};
