%token <float> NUMBER
%token <string> STRING
%token TRUE FALSE NULL
%token COMMA COLON
%token LARRAY RARRAY
%token LOBJECT ROBJECT
%token EOF

%start json
%type<Json0.t> json

%type<Json0.t> value
%type<Json0.t list> array_elements
%type<(string * Json0.t) list> object_pairs

%%

json:
  | value EOF { $1 }

value:
  /* singleton values */
  | TRUE { Bool true }
  | FALSE { Bool false }
  | NULL { Null }

  /* scalar values */
  | NUMBER { Number $1 }
  | STRING { String $1 }

  /* arrays */
  | LARRAY RARRAY { Array [] }
  | LARRAY array_elements RARRAY { Array $2 }

  /* objects */
  | LOBJECT ROBJECT { Object [] }
  | LOBJECT object_pairs ROBJECT { Object $2 }

/* one or more */
array_elements:
  | value { [$1] }
  | value COMMA array_elements { $1 :: $3 }

/* one or more */
object_pairs:
  | pair { [$1] }
  | pair COMMA object_pairs { $1 :: $3 }

pair:
  | STRING COLON value { ($1, $3) }
