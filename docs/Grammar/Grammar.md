# Grammar Rules - EBNF Form

## This language will probably be a Recursive Descent LL(1)? parser 
##  since we're mainly going to create a functional language with concurrency
##  built into it 

## Last line of the function will be the return 

<program> ::= <expression> | <definition> <program>

<definition> ::= <function-type> <identifier> '(' <parameters> ')' '->' <expression> 'end'

### A procedure don't return, fun needs to return 
<function-type> ::= 'fun' | 'proc'

### Parameters separeted by comma
<parameters> ::= <identifier> | <identifier> ',' <parameters>

<expression> ::= <function-call> | <identifier> | <number> | <string> | <boolean> | <lambda>

<function-call> ::= <expression> '(' <arguments> ')'

<arguments> ::= <expression> | <expression> ',' <arguments>
 
### We might want this for concurrency 
<lambda> ::= '\' <parameters> '->' <expression>

### We use this for name of function 
<identifier> ::= <letter> | <identifier> <letter> | <identifier> <digit>

<number> ::= <digit> | <number> <digit>

<comment> ::= '//'

<string> ::= '"' <char>* '"'

<boolean> ::= 'true' | 'false'

<letter> ::= 'a' | 'b' | ... | 'z' | 'A' | 'B' | ... | 'Z' | '_' 

<digit> ::= '0' | '1' | ... | '9'

<char> ::= <letter> | <digit> | <symbol>

<symbol> ::= '+' | '-' | '*' | '/' | '<' | '>' | '=' | ':' | '.' | ',' | ';' | '!' | '?' | '#' | '$' | '%' | '&' | '|' | '^' | '@' | '`' | '~'


### Concurrency 
Channels, Threads, Send/Receive Functionality 

### Cool features to add in the feature 
match / switch, atomics 
