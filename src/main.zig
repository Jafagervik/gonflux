const std = @import("std");
const interpreter = @import("interpreter");
const parser = @import("parser");
const lexer = @import("lexer");

fn read_file() void {}

/// Main idea at the start is to create a simple interpreter that is capable
/// of doing the most basic of tasks
pub fn main() !void {
    // Open file for reading
    const f = read_file();

    // Lex through the input
    const l = lexer.lexer(f);

    // Parse -- AST
    const p = parser.parser(l);

    // Interpret at the end
    const int = interpreter.interpret(p);
    std.debug.print("Result: {}!\n", .{int});
}
