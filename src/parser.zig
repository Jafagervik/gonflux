const std = @import("std");
const lex = @import("lexer");

pub fn parse(a: i32) void {
    var l = lex.lexer(2);
    std.debug.print("{}", .{l + a});
}
