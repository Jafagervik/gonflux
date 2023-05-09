/// Full list of all supported TokenTypes
///
/// See DataTypes.md for full list of supported tokens
pub const TokenType = enum(u8) { OperatorToken, IDENTIFIER, BOOL, FUN, PROC, END, EOF, RETURN, ARROW, OCURL, EURL, OPAREN, CPAREN, STRING };

/// Operator Tokens
const OperatorToken = enum(u8) { PLUS, MINUS, MULT, DIV, GT, LT, EQ, NEQ, GEQ, LEQ, MOD };

/// Token keywords
const KeywordTokens = enum(u8) { RETURN };
