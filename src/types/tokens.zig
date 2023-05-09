/// Full list of all supported TokenTypes
///
/// See DataTypes.md for full list of supported tokens with better explenation
pub const TokenType = enum(u8) {
    KeywordToken,
    OperatorToken,
    LiteralToken,
    SpecialToken,
    AssignmentToken,
};

/// Literaltokens
pub const LiteralToken = enum(u8) {
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
    STRING,
    CHAR,
    IDENTIFIER, // name of function or variable
    BOOL,
};

pub const AssignmentToken = enum(u8) {
    ARROW, // -> For starting the block

    COLON, // for return values
    EQUAL,
    PLUSEQUAL,
    MINUSEQUAL,
    DIVIDEEQUAL,
    MODEQUAL,
    BITANDEQUAL,
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
};

/// Tokens I dont where to place
pub const SpecialToken = enum(u8) {
    COLONCOLON, //   h :: t
    EQUALARROW, //   h => ...
    DOTDOT, // .. range
    DOTDOTEQUAL, // ..= inclusive range
    PLUSPLUS, // list and string concat
    NEWLINE, // \n
    EOF,
    UNKNOWN,
    COMMA,
    ATSIGN, // @ for builtins? hashtags??
    UNDERSCORE, // _ for patternmatching
};

/// Operator Tokens
pub const OperatorToken = enum(u8) {
    PLUS, // Pluses an operation
    MINUS,
    ASTERISK, // multiply or dereferencing
    ANDPERCEN, // reference?
    DIVIDE,
    MODULO,
    POW, // **, FIXME: Could be tricky with pointers
    BITAND,
    BITOR,
    BITXOR,
    BITSHIFTLEFT, // <<
    BITSHIFTRIGHT, // >>
    AND, // and, or, not is operators here
    OR,
    NOT,
    GREATER,
    LESS,
    EQUAL,
    NOTEQUAL,
    GREATEREQUAL,
    LESSEQUAL,
};

/// Token keywords
pub const KeywordToken = enum(u8) {
    NULL, // DO WE WANT
    PRINT,
    IF,
    ELSEIF,
    ELSE,
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
    IN, // TODO: Find out if we actually want this
};
