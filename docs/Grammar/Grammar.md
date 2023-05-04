# GonFLUX grammar rules


## Top down recursive descent instead of LL(1)??


## ====================
##  ENTRY POINT 
## ====================

### root : program eof


### program : TODO 


### function ::= TODO 

### lambda ::= 


### identifier ::= char {char_with_number}

### expression ::= TODO

### integer ::= digit {digit}

### float ::= digit {}

### string ::= char {char}

### char ::= [a-zA-Z_]

### char_with_number ::= [a-zA-Z0-9_]

### bool ::= KEYWORD_true | KEYWORD_false

### option ::= TODO

### struct ::= KEYWORD_struct identifier MINUSARROW argslist KEYWORD_end

### enum ::= KEYWORD_enum identifier MINUSARROW enum_list KEYWORD_end

### fnargs ::= LEFTPAREN argslist RIGHTPAREN 


## ==============
## Expressions 
## ==============

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
