const std = @import("std");

const ParseError = @import("errors.zig").ParseError;
const Token = @import("lexer.zig").Token;
const AST = @import("ast.zig").AST;

// Import of all subparsers
const Parsers = struct {
    const ExprParser = @import("./parser/decimals.zig");
};

/// This struct represents the parser
pub const Parser = struct {
    const Self = @This();

    /// Parses
    ///
    /// tokens: []const Token, lists
    ///
    /// return, Pointer to an AST or error
    pub fn parse(tokens: []const Token) ParseError!?*AST {
        const ast: *AST = AST.init();

        for (tokens) |*t| {
            switch (t) {
                Token.Lparen => undefined,
            }
        }

        return ast;
    }
};
