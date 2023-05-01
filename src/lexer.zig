const std = @import("std");

const lexererr = @import("errors").LexerErrors;

const Token = struct {
    type: TokenType,
    text: []const u8, // This is apparantly strings in ZIG
    pos: usize,
};

const TokenType = enum { PLUS, MINUS, MULT, DIV, IDENT, BOOL, FUN, MATCH, PROC, END, EOF };

/// This function goes through all the text from the file,
/// and then tokenizes the input
/// TODO: Check if the return type is bad practise
pub fn lexer(file: *[]const u8) anyerror![]Token {
    std.debug.print("{}", .{file});

    return lexererr;
}
