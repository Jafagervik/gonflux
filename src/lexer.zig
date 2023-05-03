const std = @import("std");

const TokenType = @import("types.zig").TokenType;

const is_space = @import("helpers.zig").is_space;

/// TODO: Improve
const lexererr = @import("errors").LexerErrors;

/// Symbol used for single line comments
pub const COMMENT_SYMBOL = '#';

/// Representation of a token in this magnificent language
pub const Token = struct {
    /// Token type
    type: TokenType,

    /// Text representation
    text: []const u8,

    /// Position in the line it occurs
    pos: usize,

    /// Beginning of next linee
    ///
    /// Thiis is\n a long\nstring you know\0.
    ///          ^       ^
    /// We call it BOL for beginning of line
    bol: usize,
};

/// This function goes through all the text from the file,
/// and then tokenizes the input
pub const Lexer = struct {
    const Self = @This();

    /// Current position in file
    pos: usize = 0,

    /// Beginning of Line
    bol: usize = 0,

    /// Row
    row: usize = 0,

    /// Source data to read in from
    source: []const u8 = undefined,

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

        // Iterate and get next token
        var token = self.next_token();

        while (token != 0) : (token = self.next_token()) {
            std.debug.print("Token", .{token});
        }

        // Next step is to parse this token list
        return token_list.items;
    }

    // ==========================
    //   INTERNALS
    // ==========================
    fn trim_left(self: *Self) void {
        while (self.is_not_empty() and is_space(self.source[self.pos])) {
            self.chop_char();
        }
    }

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

    /// Get the next token in this file
    /// False means end of token
    fn next_token(self: *Self) bool {
        self.trim_left();

        // Ignore comments...
        while (self.is_not_empty() and self.source[self.pos] == COMMENT_SYMBOL) {
            self.drop_line();
            self.trim_left();
        }

        if (self.empty()) return false;
    }

    fn get_char(line: []u8) u8 {
        var idx: usize = 0;

        while (idx < line.len) : (idx += 1) {
            return 0;
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

    /// Yield a new file line by line
    /// TODO: file should here be a buffer we take the the first line of
    fn next_line(file: *[]u8) anyerror![]u8 {
        var idx = 0;

        var line_buf: [:0]u8 = undefined;

        // TODO: Make sure we're only reading what we need to
        while (file[idx] != '\n') : (idx += 1) {
            line_buf[idx] = file[idx];
        }

        return line_buf;
    }
};

test "docs" {
    std.testing.refAllDecls(Lexer);
}
