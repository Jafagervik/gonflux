const std = @import("std");
const ERR = @import("errors");

const AST = @import("parser").AST;

pub fn interpret(ast: AST) anyerror!void {
    std.debug.print("22 {}", .{ast});
}
