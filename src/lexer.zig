const std = @import("std");

const lexererr = @import("errors").LexerErrors;

/// Representation of a token in this magnificent language
const Token = struct {
    type: TokenType,
    text: []const u8,
    pos: usize,
};

/// Full list of all supported TokenTypes
///
/// PLUS,
/// MINUS,
/// MULT,
/// DIV,
/// MOD,
/// BOOL,
/// GT,
/// LT,
/// EQ,
/// NEQ,
/// GEQ,
/// LEQ,
/// END,
/// ARROW,
/// MATCH,
/// LAMBDA \x,y -> x + y end
/// IDENT
/// NUMBER
/// STRING
/// CHAR
const TokenType = enum { PLUS, MINUS, MULT, DIV, IDENT, BOOL, FUN, MATCH, LT, GT, EQ, NEQ, PROC, END, EOF };

/// This function goes through all the text from the file,
/// and then tokenizes the input
pub const Lexer = struct {
    const root = @This();
};
