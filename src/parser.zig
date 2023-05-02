const std = @import("std");

// TODO: Change the name of this one
const parseerr = @import("errors.zig").ParseErrors;
const lexer = @import("lexer.zig");
const AST = @import("ast.zig").AST;

/// Parse into AST
pub const Parser = struct {
    const root = @This();

    pub fn parse(tokens: []lexer.Token) anyerror!AST {
        for (tokens) |t| {
            switch (t) {
                lexer.Token => undefined,
            }
        }
    }
};
