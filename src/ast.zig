//! Abstract Syntax Tree representing GonFLUX

const std = @import("std");
const Parser = @import("parser.zig").Parser;

/// AST - Our abstract syntax tree
pub const AST = struct {
    const Tag = enum { AST_INTEGER, AST_DECIMAL, AST_STRING, AST_CHAR };

    const Data = union {
        const AST_INTEGER = struct {
            number: i32,
        };

        const AST_DECIMAL = struct {
            number: f32,
        };

        const AST_ADD = struct {
            left: ?*AST_ADD,
            right: ?*AST_ADD,
        };

        const AST_SUB = struct {
            left: ?*AST_SUB,
            right: ?*AST_SUB,
        };
    };
};

test "docs" {
    std.testing.refAllDecls(@This());
}
