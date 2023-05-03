const std = @import("std");

const TokenType = @import("types.zig").TokenType;

const is_space = @import("helpers.zig").is_space;

/// TODO: Improve
const lexererr = @import("errors").LexerErrors;

/// Symbol used for single line comments
pub const COMMENT_SYMBOL = '#';

/// Location directly return the struct

//pub fn Location(fp: []const u8, r: u8, c: u8) type {
//    return struct {
//       /// Name of file it happened at
//        file_path: []const u8 = fp,
//
//        /// Row
//        row: usize = r,
//
//       /// Coolumn
//        col: usize = c,
//   };
//}

/// TODO: Find out which of these 2 methods are more idiomatic
pub const Location = struct {
    const Self = @This();

    /// fp
    file_path: []const u8 = undefined,

    row: usize = 0,

    col: usize = 0,

    pub fn init(self: *Self, fp: []const u8, r: usize, c: usize) Self {
        self.file_path = fp;
        self.row = r;
        self.col = c;
        return self;
    }

    /// TODO: Write this out to stdout in the future
    pub fn display(self: *Self) void {
        std.debug.log("{s} {d} {d}\n", .{ self.file_path, self.row, self.col });
    }
};

/// Representation of a token in this magnificent language
pub const Token = struct {
    const Self = @This();

    /// Token type
    type: TokenType,

    /// Value of token
    value: []const u8,

    ///  Location
    location: Location,

    /// Defult Token impl
    pub fn init(self: *Self, loc: Location, t: TokenType, val: []const u8) Self {
        self.location = loc;
        self.type = t;
        self.value = val;
        return self;
    }
};

/// This function goes through all the text from the file,
/// and then tokenizes the input
pub const Lexer = struct {
    const Self = @This();

    /// File Path that is no being run
    file_path: []const u8 = undefined,

    /// Source data to read in from
    source: []const u8 = undefined,

    // TODO: should this be location instead
    /// Current position in data, also called cursor
    cur: usize = 0,

    /// Beginning of Line
    bol: usize = 0,

    /// Row
    row: usize = 0,

    pub fn tokenize(self: *Self, file: []const u8) anyerror![]const Token {
        self.source = file;

        var source_size: usize = self.source.len;
        std.debug.print("Size is {}", .{source_size});

        var buffer: [2048]u8 = undefined;
        var fba = std.heap.FixedBufferAllocator.init(&buffer);
        const allocator = fba.allocator();

        var token_list = std.ArrayList(Token).init(allocator);
        // TODO: Remove if needed
        defer token_list.deinit();

        // TODO: Implement main loop of tokenizer
        // Iterate and get next token
        var token = self.next_token();

        while (token != 0) : (token = self.next_token()) {
            std.debug.print("Token", .{token});
        }

        // Return a list over the tokens we want to interact with
        return token_list.items;
    }

    // ==========================
    //   INTERNALS
    // ==========================

    // TODO: Engineer this a bit better
    /// Get the next token in this file
    /// False means end of token
    fn next_token(self: *Self) bool {
        // Trim indentation
        self.trim_left();

        // Ignore comments
        while (self.is_not_empty() and self.source[self.pos] == COMMENT_SYMBOL) {
            self.drop_line();
            self.trim_left();
        }

        var token = Token{};
        // TODO: not assigning correct type here
        token.location = self.cur;

        if (self.empty()) return false;

        var loc = self.cur;

        // Get characters while they're alphanum
        if (std.ascii.isAlphanumeric(self.source)) {
            var idx = self.pos;

            while (self.is_not_empty() and std.ascii.isAlphanumeric(self.source(self.pos))) {
                self.chop_char();
            }

            // First tokenizer
            return Token.init(loc, "TOKENNAME", self.source[idx..self.cursor]);
        }
    }

    /// Check that cursor is not totally out
    fn is_not_empty(self: *Self) bool {
        return self.pos < self.source.len;
    }

    /// Check if this is empty
    fn is_empty(self: *Self) bool {
        return !self.is_not_empty();
    }

    // TODO: Implement
    fn trim_left(self: *Self) void {
        _ = self;
        //while (self.is_not_empty() and is_space(self.source[self.pos])) {
        //    self.chop_char();
        //}
    }

    /// "Chops" off characters
    fn chop_char(self: *Self) void {
        if (self.is_not_empty()) {
            var x = self.source[self.pos];
            self.pos += 1;

            // We are now at the next line
            if (x == '\n') {
                self.bol = self.pos;
                self.row += 1;
            }
        }
    }
};

test "docs" {
    std.testing.refAllDecls(Lexer);
}

test "lexing" {
    const fp = "./test_lex.gflx";

    const lexer = Lexer.tokenize(fp);
    _ = lexer;

    std.testing.expect(2 + 2 == 4);
    // std.testing.expect(lexer[0] == token1);
    // std.testing.expect(lexer[0] == token2);
    // std.testing.expect(lexer[0] == token3);
    // std.testing.expect(lexer[0] == token4);

}
