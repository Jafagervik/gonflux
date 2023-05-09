const std = @import("std");

const Lexer = @import("lexer.zig");
// const Parser = @import("parser.zig").Parser;
// const AST = @import("ast.zig").AST;
const helpers = @import("helpers.zig");
const Constants = @import("constants.zig");

const TESTFILE: []const u8 = "./src/test.gflx";
const BUFSIZE: usize = std.math.maxInt(usize);

pub fn main() anyerror!void {
    helpers.prints(Constants.GFLX);

    // _ = ArgsParser.parse();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Get the path
    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const path = try std.fs.realpath(TESTFILE, &path_buffer);

    // Open file
    const file = try std.fs.openFileAbsolute(path, .{});

    // TODO: Find out if we're just gonna return a pointer to path instead
    const payload = try file.readToEndAlloc(allocator, BUFSIZE);

    for (payload, 0..) |char, idx| {
        std.debug.print("{d:>2}: {c}\n", .{ idx, char });
    }

    // Lexical Analysis
    var lexer = Lexer.Lexer.init(TESTFILE, payload);
    _ = lexer;

    // var token: *TokenIter = try lexer.tokenize(payload);

    // var tokens = try lexer.tokenize(payload);
    //
    // while (tokens.next()) |*token| {
    //     token.print();
    // }

    // TODO: Clean up resources as early as possible for the future
    allocator.free(payload);
    file.close();
}
