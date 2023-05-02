const std = @import("std");
const Lexer = @import("lexer.zig").Lexer;
const Parser = @import("parser.zig").Parser;
const AST = @import("ast.zig").AST;

/// Interpreter written for GonFLUX
pub const Interpreter = struct {
    var filename: [:0]u8 = undefined;

    const Self = @This();

    fn build(self: *Self, file_name: [:0]u8) void {
        self.filename = file_name;
    }

    /// Run the interpreter with given filename
    ///
    /// 1. Tokenize the file aka Run Lexer
    ///
    /// 2. Parse the tokens and generate AST
    ///
    /// 3. Use the AST to interpret the code
    ///
    /// 4. Voila!
    fn run() !void {
        // Tokenizer
        const tokens = Lexer.tokenize(filename);

        // Parse
        const parsed = Parser.parse(tokens);

        // AST
        const ast = AST.generate(parsed);

        // Run the interpreter
        interpret(ast);
    }

    /// Internal runner for the code we're trying so hard to run
    fn interpret() !void {}
};

test "docs" {
    std.testing.refAllDecls(@This());
}
