const std = @import("std");

const lex = @import("lexer.zig");
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
    defer file.close();

    // TODO: Find out if we're just gonna return a pointer to path instead
    const payload = try file.readToEndAlloc(allocator, BUFSIZE);
    defer allocator.free(payload);

    if (Constants.DEBUG) {
        for (payload, 0..) |char, idx| {
            std.debug.print("{d:>2}: {c}\n", .{ idx, char });
        }
    }

    // Lexical Analysis
    var lexer: lex.Lexer = lex.Lexer.init(TESTFILE, payload);

    std.debug.print("{d} {d} {d}\n\n {s}\n", .{ lexer.cursor, lexer.beginning_of_line, lexer.row, lexer.data });

    // TODO: If lex fails, report error and exit
    // var token_iterator: TokenIter = try lexer.tokenize(payload);

    // while (token_iterator.next()) |*token| {
    //     token.print();
    // }

}
