const std = @import("std");

const L = @import("lexer.zig");

pub fn main() anyerror!void {
    const filedata = @embedFile("test.gflx");

    std.debug.print("Type of data is {}\n", .{@TypeOf(filedata)});
    std.debug.print("This is just a test {s}\n", .{filedata});

    // This is the current state of our lexer
    var lex: L.Lexer = L.Lexer{};

    // Tokenize our wonderful sourcefile
    const token_list = try lex.tokenize(filedata);

    for (token_list) |tok| {
        std.debug.print("Token is: {}\n", .{tok});
    }
}

test "Current Implementation" {
    std.testing.expect(1 + 1 == 2);
}
