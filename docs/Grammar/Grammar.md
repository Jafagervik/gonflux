# GonFLUX grammar rules


## Top down recursive descent instead of LL(1)??


## ====================
##  ENTRY POINT 
## ====================

### root : program eof


### program : TODO 


## ======================
##   FUNCTIONS 
## ======================

### function ::= function_return | function_no_return
 
### function_no_return ::= KEYWORD_proc function_commons KEYWORD_end

### function_return ::= KEYWORD_fn function_commons KEYWORD_return expr KEYWORD_end

### lambda ::= BACKSLASH function_params MINUSARROW expr KEYWORD_end

### function_commons ::= identifier fnargs COLON datatype MINUSARROW exprlist 

### fnargs ::= LEFTPAREN {function_params} RIGHTPAREN 

### function_params ::= variable_definition {COMMA variable_definition}


## ===========================
##   Expressions
## ===========================

### accepted_list_types ::= integer | float | string | char | bool | option

### identifier ::= char {char_with_number}

### expression ::= TODO

### integer ::= digit {digit}

### float ::= integer | { digit {digit } DOT digit {digit} }

### string ::= char {char} 

### digit ::= [0-9]

### digit1 ::= [1-9]

### char ::= [a-zA-Z_]

### char_with_number ::= [a-zA-Z0-9_]

### bool ::= KEYWORD_true | KEYWORD_false

### option ::= TODO

### struct ::= KEYWORD_struct identifier MINUSARROW function_params KEYWORD_end

### list ::= LEFTCURLYPAREN {accepted_list_types} RIGHTCURLYPAREN



## ================ 
##   If expression 
## ================

## TODO: Rewrite this in proper EBNF form
### if_stmt ::= KEYWORD_if LEFTPAREN expr RIGHTPAREN KEYWORD_then exprlist END 
### elseif_stmt ::= KEYWORD_elseif LEFTPAREN expr RIGHTPAREN KEYWORD_then exprlist END 
### else_stmt ::= KEYWORD_else KEYWORD_then exprlist end 

## ============
## MATCH 
## ============

### match_statement ::= KEYWORD_match LEFTPAREN indentifier RPAREN MINUSARROW match_list KEYWORD_end

### match_list ::= match_clause {match_clause}

### match_clause ::= pattern_list EQUALARROW COMMA

### pattern_list ::= rangelists | LEFTRIGHTCURLYPAREN | head_tail_pattern | UNDERSCORE

### head_tail_pattern :: identifier {COLONCOLON identifier}

## ===================
## Ranges  
## =================== 

### rangelists ::= rangelist | rangelist_no_start | rangelist_no_end

### rangelist ::= integer DOTDOT integer 
### rangelist_no_start ::= DOTDOT integer
### rangelist_no_end ::= integer DOTDOT

## NOTE: For now, enum will be an algebraic datatype
### enum ::= KEYWORD_enum identifier MINUSARROW function_params KEYWORD_end


### variable_definition ::= identifier COLON datatype


## ==========================================
##  TODO: Find out which datatypes we want
## ==========================================
### datatype ::= i32 | u32 | str | f32 | bool | char | TODO: add more 


## =============
##  Misc 
## =============

### import: KEYWORD_import AT indentifier

## ========================
##  Operator List 
## ========================

### assignmentops ::= 

### compareops ::=

### multiplyops ::=

### additionops ::= 

## ==========================
## List of function keywords 
## ==========================

### FunctionKeyword ::= KEYWORD_fn | KEYWORD_proc


### empty_list ::= LEFTCURLYPAREN RIGHTCURLYPAREN

### head_tail ::= identifier COLONCOLON

## =====================
##   Every operator used
## =====================

### MINUS ::= '-'
### PLUS ::= '+'
### DIV ::= '/'
### FLOOR ::= '//'
### PLUS2 ::= '++'
### ANDPERSAND ::= '&'
### ASTERISK ::= '*'
### MINUSARROW ::= '->'
### EQUALARROW ::= '=>'
### EQUALEQUAL ::= '=='
### DOT ::= '.'
### BACKSLASH ::= '\'
### DOTDOT ::= '..'
### PERCENT ::= '%'
### PIPEPIPE :== '||'
### COLON :== ':'
### LEFTPAREN :== '('
### RIGHTPAREN :== ')'
### LEFTCURLYPAREN :== '['
### RIGHTCURLYPAREN :== ']'
### LEFTRIGHTCURLYPAREN :== '[]'
### COLONCOLON ::== '::'
### UNDERSCORE ::= '_'
### AT ::= '@'

## ====================
##  KEYWORDS 
## ====================

### KEYWORD_or     ::= 'or' wordend
### KEYWORD_if     ::= 'if' wordend
### KEYWORD_and    ::= 'and' wordend
### KEYWORD_then   ::= 'then' wordend
### KEYWORD_else   ::= 'else' wordend
### KEYWORD_match  ::= 'match' wordend
### KEYWORD_proc   ::= 'proc' wordend
### KEYWORD_fn     ::= 'fn' wordend
### KEYWORD_end    ::= 'end' wordend
### KEYWORD_enum   ::= 'enum' wordend
### KEYWORD_import ::= 'import' wordend
### KEYWORD_return ::= 'return' wordend
### KEYWORD_elseif ::= 'elseif' wordend
### KEYWORD_struct ::= 'struct' wordend


### keyword ::= KEYWORD_or | KEYWORD_if | KEYWORD_and | KEYWORD_then | KEYWORD_else | KEYWORD_match | KEYWORD_proc | KEYWORD_fn | KEYWORD_end | KEYWORD_enum | KEYWORD_import | KEYWORD_return | KEYWORD_elseif | KEYWORD_struct | KEYWORD_true | KEYWORD_false
