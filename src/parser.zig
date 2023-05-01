const std = @import("std");

const parseerr = @import("Errors").ParseErrors;
const Token = @import("Lexer").Token;

const AST = struct {};

pub fn parse(tokens: []Token) anyerror!AST {
    tokens;
    return parseerr;
}
