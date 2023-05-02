const std = @import("std");
const Parser = @import("parser.zig").Parser;

/// AST - Our abstract syntax tree
pub const AST = struct {
    pub fn generate(parsed: Parser) void {
        _ = parsed;
    }
};

test "docs" {
    std.testing.refAllDecls(@This());
}
