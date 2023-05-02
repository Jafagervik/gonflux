const std = @import("std");

const parseerr = @import("errors.zig").ParseErrors;
const lexer = @import("lexer.zig").Token;

const AST = struct {};

pub fn parse(tokens: []lexer.Token) anyerror!AST {
    tokens;
    return parseerr;
}

/// Parse into AST
pub const Parser = struct {
    const root = @This();

    pub fn parser(tokens: []lexer.Token) anyerror!AST {
        for (tokens) |t| {
            switch (t) {
                lexer.Token => undefined,
            }
        }
    }
};
