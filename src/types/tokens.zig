/// Full list of all supported TokenTypes
///
/// See DataTypes.md for full list of supported tokens with better explenation
pub const TokenType = enum(u8) {
    // LITERALS

    U8,
    U16,
    U32,
    U64,
    U128,
    I8,
    I16,
    I32,
    I64,
    I128,
    F8, // TODO: is it really needed?
    F16,
    F32,
    F64,
    F128,
    INTEGER,
    FLOAT,
    STRING,
    CHAR,
    IDENTIFIER, // name of function or variable
    BOOL,

    ARROW, // -> For starting the block

    COLON, // for return values
    EQUAL,
    PLUSEQUAL,
    MINUSEQUAL,
    ASTERISKEQUAL, // *=
    DIVIDEEQUAL,
    MODEQUAL,
    BITANDEQUAL,
    BITNOTEQUAL, // ~=
    BITOREQUAL,
    BITXOREQUAL,
    BITSHIFTLEFTEQUAL,
    BITSHIFTRIGHTEQUAL,
    ASSIGNMENTEND, // Possibly nothing, since we don't allow this currently
    // Now for the list destructuring
    CONCATEQUAL, // ++=

    // Brackets
    PARENTOPEN,
    PARENTCLOSE,
    BRACEOPEN,
    BRACECLOSE,
    BRACKETOPEN,
    BRACKETCLOSE,

    END, // End is both a keyword and a assignment for somethings

    // OPERATORS

    PLUS, // Pluses an operation
    MINUS,
    ASTERISK, // multiply or dereferencing
    DIVIDE,
    MODULO,
    POW, // **, FIXME: Could be tricky with pointers
    BITAND,
    BITNOT,
    BITOR,
    BITXOR,
    BITSHIFTLEFT, // <<
    BITSHIFTRIGHT, // >>
    AND, // and, or, not is operators here
    OR,
    NOT,
    GREATER,
    LESS,
    NOTEQUAL,
    GREATEREQUAL,
    LESSEQUAL,

    // SPECIALS

    QUOTE, // '
    DOUBLEQUOTE, // "
    COLONCOLON, //   h :: t
    EQUALARROW, //   h => ...
    DOTDOT, // .. range
    DOTDOTEQUAL, // ..= inclusive range
    PLUSPLUS, // list and string concat
    NEWLINE, // \n
    EOF,
    PIPE, // |
    ANDPERCEN, // Can both be for bit logic and references
    UNKNOWN,
    COMMA,
    ATSIGN, // @ for builtins? hashtags??
    UNDERSCORE, // _ for patternmatching

    // KEYWORDS

    NULL, // DO WE WANT
    PRINT,
    IF,
    ELSEIF,
    ELSE,
    THEN,
    WHILE,
    FOR,
    MUT,
    BREAK,
    FN,
    CONTINUE,
    RETURN,
    THROW,
    TRY,
    CATCH,
    IMPORT,
    EXPORT,
    PUBLIC,
    TYPE,
    INLINE,
    TYPEOF,
    ENUM,
    STRUCT,
    ATOMIC, // atomic before type marks it as an atomic!
    IN, // TODO: Find out if we actually want this
    POINTER, // Pointer[i32]
};
