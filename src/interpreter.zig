const std = @import("std");

const AST = @import("ast.zig");

pub fn interpret(ast: AST.AST) anyerror!void {
    std.debug.print("{any}", .{ast});
}

pub const Interpreter = struct {};
