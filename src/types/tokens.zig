/// Full list of all supported TokenTypes
///
/// See DataTypes.md for full list of supported tokens with better explenation
pub const TokenType = enum(u8) {
    // LITERALS

    INTEGER, // 4
    FLOAT, // 3.23
    STRING, // "sfdg"
    CHAR, // 'c'
    IDENTIFIER, // name of function or variable _abcDEF123
    BOOL, // true
    POINTER, // Pointer[]

    ARROW, // -> For starting the block

    COLON, // : for return values
    EQUAL, // =
    PLUSEQUAL, // +=
    MINUSEQUAL, // -=
    ASTERISKEQUAL, // *=
    DIVIDEEQUAL, // /=
    MODEQUAL, // %=
    BITANDEQUAL, // &=
    BITNOTEQUAL, // ~=
    BITOREQUAL, // |=
    BITXOREQUAL, // ^
    BITSHIFTLEFTEQUAL, // <<=
    BITSHIFTRIGHTEQUAL, // >>=
    ASSIGNMENTEND, // Possibly nothing, since we don't allow this currently
    // Now for the list destructuring
    CONCATEQUAL, // ++=

    // Brackets
    PARENTOPEN, // (
    PARENTCLOSE, // )
    BRACEOPEN, // [
    BRACECLOSE, // ]
    BRACKETOPEN, // {
    BRACKETCLOSE, // }

    END, // end     End is both a keyword and a assignment for somethings

    // OPERATORS

    PLUS, // +
    MINUS, // -
    ASTERISK, // *  multiply or dereferencing
    DIVIDE, // /
    MODULO, // %
    POW, // ** ,  FIXME: Could be tricky with pointers
    BITAND, // &
    BITNOT, // ~
    BITOR, // |
    BITXOR, // ^
    BITSHIFTLEFT, // <<
    BITSHIFTRIGHT, // >>
    AND, // and, or, not is operators here
    OR, // or
    NOT, // not
    GREATER, // >
    LESS, // <
    NOTEQUAL, // !=
    GREATEREQUAL, // >=
    LESSEQUAL, // <=

    // SPECIALS

    QUOTE, // '
    DOUBLEQUOTE, // "
    COLONCOLON, //   ::
    EQUALARROW, //   =>
    DOTDOT, // .. range
    DOTDOTEQUAL, // ..= inclusive range
    PLUSPLUS, // ++ list and string concat
    NEWLINE, // \n
    EOF, // EOF
    PIPE, // |
    ANDPERCEN, // &  Can both be for bit logic and references
    UNKNOWN, // ???
    COMMA, // ,
    ATSIGN, // @ for builtins? hashtags??
    UNDERSCORE, // _ for patternmatching

    // KEYWORDS

    NULL, // null  DO WE WANT ?
    IF, // if
    ELSEIF, // elseif
    ELSE, // else
    THEN, // then
    WHILE, // while
    FOR, // for
    MUT, // mut
    BREAK, // break
    FN, // fn
    MATCH, // match
    CONTINUE, // continue
    RETURN, // return
    THROW, // throw
    TRY, // try
    CATCH, // catch
    IMPORT, // import
    EXPORT, // export
    PUBLIC, // pub or public
    TYPE, // type
    INLINE, // inline
    TYPEOF, // typeof
    ENUM, // enum
    STRUCT, // struct
    ATOMIC, // atomic before type marks it as an atomic!
    IN, // in   TODO: Find out if we actually want this
};
