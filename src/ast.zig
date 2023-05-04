//! Abstract Syntax Tree representing GonFLUX

const std = @import("std");
const Parser = @import("parser.zig").Parser;
// TODO: Move types here
const ASTTypes = @import("types.zig").ASTTypes;

/// Type of parsed token
pub const ASTDataType = enum {
    ASTExpression,
};

/// Stores information about each parsed token
pub const ASTNode = struct {
    name: []const u8,
    dtype: ASTDataType,
    children: [*]ASTNode,
    parent: *ASTNode,
};

/// AST - Our abstract syntax tree
pub const AST = struct {
    const Root = @This();

    /// Constructs the AST From the Nodes
    pub fn constructAST() AST {}

    /// Prints the entire AST for the program
    pub fn printAST(current: *ASTNode) !void {
        if (current.children) |children| {
            for (children) |*c| {
                std.debug.print(current.name);
                printAST(c);
            }
        }
    }
};

test "AST" {
    std.testing.expect(11 == 11);
}

test "docs" {
    std.testing.refAllDecls(@This());
}
