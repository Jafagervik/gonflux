const std = @import("std");

const L = @import("lexer.zig");
const Parser = @import("parser.zig").Parser;
const AST = @import("ast.zig").AST;
const helpers = @import("helpers.zig");
const args = @import("args.zig");

const NAME: []const u8 =
    \\
    \\   ============  =========== ==         ==         ==
    \\   ============  =========== ==          ==       ==
    \\   ==            ==          ==           ==     ==
    \\   ==            ==          ==            ==   ==
    \\   ==            =========== ==             == ==
    \\   ============= =========== ==              == 
    \\   ============= ==          ==            ==  ==
    \\   ==         == ==          ==           ==    ===
    \\   ==         == ==          ==========  ==       ==
    \\   ============= ==          ========== ==         ==
    \\
;

const TESTFILE: []const u8 = "./test.gflx";
const BUFSIZE: usize = std.math.maxInt(usize);

const RuntimeMode = enum { DEBUG, RELEASE };
const mode = RuntimeMode.DEBUG;

pub fn main() !void {
    std.debug.info("{s}", .{NAME});

    // Parse arguments
    args.parse();

    //  Get an allocator
    var gp = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gp.deinit();
    const allocator = &gp.allocator;

    // Open file
    const payload = helpers.readFile(TESTFILE, BUFSIZE, allocator);
    defer allocator.free(payload);

    // Lexical Analysis
    var lexer: L.Lexer = L.Lexer{};

    // Tokenize the data
    var token_list: std.ArrayList(L.Token) = try lexer.tokenize(payload);

    if (mode.DEBUG == true) {
        for (token_list) |tok| {
            std.debug.print("Token Type: {} \t\t Value: {}\n", .{ tok.token, tok.value });
        }
    }

    // Parse the token list and construct the AST
    const ast: *AST = Parser.parse(*token_list);
    _ = ast;

    // Compilation or potentially not
}

test "Current Implementation" {
    std.testing.expect(1 + 1 == 2);
}
