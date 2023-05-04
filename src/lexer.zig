const std = @import("std");

const TokenType = @import("types.zig").TokenType;

const isSpace = @import("helpers.zig").isSpace;

const LexerError = @import("errors.zig").LexerError;

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

// TODO: Find out which of these 2 methods are more idiomatic
/// Represents a tokens position in the file
pub const Location = struct {
    const Self = @This();

    file_descriptor: []const u8 = undefined,

    row: usize = 0,

    col: usize = 0,

    pub fn init(fd: []const u8, r: usize, c: usize) Location {
        return Location{ .file_dscriptor = fd, .row = r, .col = c };
    }

    pub fn display(self: *Self) void {
        std.debug.log("{s} {d} {d}\n", .{ self.file_path, self.row, self.col });
    }
};

/// Representation of a token in this magnificent language
pub const Token = struct {
    /// Token type
    type: TokenType,

    /// Value of token
    value: []const u8,

    /// Location of token in file
    location: Location,

    /// Initializes a new Token
    pub fn init(loc: Location, t: TokenType, val: []const u8) Token {
        return Token{ .location = loc, .type = t, .value = val };
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

    /// Current position in data, also called cursor
    cur: usize = 0,

    /// Beginning of Line
    bol: usize = 0,

    /// Row
    row: usize = 0,

    /// Tokenizes a .gflx source file
    ///
    /// payload: []const u8, input file
    ///
    /// returns, List of tokens or a LexerError
    pub fn tokenize(self: *Self, payload: []const u8) LexerError![]const Token {
        self.source = payload;

        const token_buffer_size: usize = std.math.maxInt(usize);

        var source_size: usize = self.source.len;
        std.debug.print("Size of file is {}", .{source_size});

        // Buffer for the array list containing the tokens
        var buffer: [token_buffer_size]u8 = undefined;
        var fba = std.heap.FixedBufferAllocator.init(&buffer);
        const allocator = fba.allocator();

        var token_list = std.ArrayList(Token).init(allocator);
        defer token_list.deinit();

        // TODO: Implement main loop of tokenizer
        // Iterate and get next token
        var token = self.next_token();

        while (token != 0) : (token = self.next_token()) {
            std.debug.print("Token", .{token});
        }

        // Example of how to create an error
        if (2 == 3) {
            std.debug.panic("Oops, wrong!\n");
            return LexerError.UnknownTokenError;
        }

        // Return a list over the tokens we want to interact with
        return token_list.items;
    }

    // ==========================
    //   INTERNALS
    // ==========================

    /// Get the next token in this file
    ///
    /// return, token or a lexer error
    fn getNextToken(self: *Self) LexerError!Token {
        // Trim indentation
        self.trimLeft();

        // Ignore comments
        while (self.isNotEmpty() and self.source[self.pos] == COMMENT_SYMBOL) {
            self.dropLine();
            self.trimLeft();
        }

        var token = Token{};
        // TODO: not assigning correct type here
        token.location = self.cur;

        if (self.empty()) return false;

        var loc = self.cur;

        // Get characters while they're alphanum
        if (std.ascii.isAlphanumeric(self.source)) {
            var idx = self.pos;

            while (self.isNotEmpty() and std.ascii.isAlphanumeric(self.source(self.pos))) {
                self.chopChar();
            }

            // First tokenizer
            return Token.init(loc, "TOKENNAME", self.source[idx..self.cursor]);
        }
    }

    /// Check that cursor is not totally out
    fn isNotEmpty(self: *Self) bool {
        return self.pos < self.source.len;
    }

    // TODO: Implement
    fn trimLeft(self: *Self) void {
        _ = self;
        //while (self.isNotEmpty() and isSpace(self.source[self.pos])) {
        //    self.chopChar();
        //}
    }

    /// "Chops" off characters
    fn chopChar(self: *Self) void {
        if (self.isNotEmpty()) {
            var x = self.source[self.pos];
            self.pos += 1;

            // We are now at the next line
            if (std.ascii.isWhitespace(x)) {
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
    const data: []const u8 =
        \\proc main() ->
        \\    a: i32 = 1 + 2
        \\    b: i32 = a * 4
        \\    name = "Hello!"
        \\    print(name)
        \\end
        \\
        \\main()
    ;

    const lexer = Lexer.tokenize(data);
    std.testing.expect(lexer[0] == Token.Procedure);
    std.testing.expect(lexer[0] == Token.Identifier);
    std.testing.expect(lexer[0] == Token.LParen);
    std.testing.expect(lexer[0] == Token.RParen);
}
