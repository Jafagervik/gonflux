const std = @import("std");
const ArrayList = std.ArrayList;

const TokenType = @import("types.zig").TokenType;
const Constants = @import("constants.zig");

const LexerError = @import("errors.zig").LexerError;
const helpers = @import("helpers.zig");

/// Token iterator type
const TokenIterator = ?*Token;

/// Represents a tokens position in the file
pub const Location = struct {
    const Self = @This();

    /// Name of file
    file_descriptor: []const u8 = undefined,

    /// Row of lexeme
    row: usize = undefined,

    /// Col of lexeme
    col: usize = undefined,

    /// Init the location
    pub fn init(fd: []const u8, r: usize, c: usize) Location {
        return Location{ .file_descriptor = fd, .row = r, .col = c };
    }

    /// Prints debug info about the Location of a Token
    pub fn print(self: Self) void {
        std.debug.log("{s} {d} {d}\n", .{ self.file_path, self.row, self.col });
    }
};

/// Representation of a token in this magnificent language
pub const Token = struct {
    const Self = @This();

    /// Token type
    tokenType: TokenType = undefined,

    /// Symbols making up the lexeme
    lexeme: []const u8 = undefined,

    /// Location of the Token
    location: Location = undefined,

    /// Following token
    nextToken: ?*Token = null,

    /// Initializes a new Token
    pub fn init(loc: Location, t: TokenType, value: []const u8) Token {
        return Token{ .location = loc, .tokenType = t, .lexeme = value };
    }

    /// Prints out the token
    pub fn print(self: Self) void {
        std.debug.print("Type: {d}\tLexeme: {s}\tRow: {d}\t Col: {d}\n", .{ @enumToInt(self.tokenType), self.lexeme, self.location.row, self.location.col });
    }

    /// Gives us the next token as long as there exists one
    ///
    /// Returns a TokenIterator: *Token
    pub fn next(self: *Self) TokenIterator {
        if (self.nextToken) {
            return self.next;
        } else {
            return null;
        }
    }
};

/// This function goes through all th0
pub const Lexer = struct {
    const Self = @This();

    /// File Path that is now being run
    file_path: []const u8 = undefined,

    /// Source data to read in from
    data: []u8 = undefined,

    /// Current index of file we're looking at, also called cursor
    cursor: usize = 0,

    /// Beginning of the current line
    beginning_of_line: usize = 0,

    /// Current row in file
    row: usize = 0,

    // COL = CURSOR - BEGINNING OF LINE

    /// Initializes the lexer struct and prepares for tokenization
    ///
    /// file_path: str, absolute filepath to source file
    /// payload: char iterator, every char to read from
    pub fn init(file_path: []const u8, payload: []u8) Lexer {
        return Lexer{ .file_path = file_path, .data = payload };
    }

    /// Tokenizes source file and returns an iterator
    /// we can use to parse for
    ///
    /// Returns: Pointer to token iterator or LexerError
    pub fn tokenize(self: Self) LexerError!*Token {
        // So we have something to look at
        self.trimLeft();

        var start_of_lexeme = self.cursor;

        // FIND THE FIRST TOKEN AND GO FROM THERE
        if (std.ascii.isAlphabetic(self.data[self.cursor])) {}

        while (!std.ascii.isWhitespace(self.data[self.cursor])) : (self.cursor += 1) {}

        var lexeme_slice: [_]u8 = self.data[start_of_lexeme..self.cursor];

        // Handle first token
        var rootToken: *Token = &Token.init();

        for (self.data, 0..) |symbol, idx| {
            self.cursor = idx;
        }

        // FIXME: Remove after testing has finished
        var loc: Location = Location.init(payload, 42, 42);
        var t: Token = Token.init(loc, TokenType.ARROW, "hello");

        rootToken = &t;

        return rootToken;
    }

    /// Moves the cursor until we get to the next token
    fn chopSpace(self: Self) void {
        while (helpers.isSpace(self.data[self.cursor])) : (self.cursor += 1) {}
    }

    /// Trims file until there actually is source code to look at
    fn trimLeft(self: Self) void {
        while (helpers.isSpace(self.data[self.cursor])) : (self.cursor += 1) {}
    }
};

test "docs" {
    std.testing.refAllDecls(Lexer);
}

test "lexical analysis" {
    const data: []const u8 =
        \\fn main() ->
        \\    a: i32 = 1 + 2
        \\    b: i32 = a * 4
        \\    name = "Hello!"
        \\end
    ;

    var scanner = Lexer.init("./test.gflx", data);
    var iter = scanner.tokenize();

    var tok1 = try iter.next();
    std.testing.expect(tok1.*.tokenType == TokenType.FnToken);

    var tok2 = try iter.next();
    std.testing.expect(tok2.*.tokenType == TokenType.MainIndetifierToken);

    var tok3 = try iter.next();
    std.testing.expect(tok3.*.tokenType == TokenType.LParenToken);

    var tok4 = try iter.next();
    std.testing.expect(tok4.*.tokenType == TokenType.RParenToken);

    var tok5 = try iter.next();
    std.testing.expect(tok5.*.tokenType == TokenType.ColonToken);

    var tok6 = try iter.next();
    std.testing.expect(tok6.*.tokenType == TokenType.DataTypeToken);

    var tok7 = try iter.next();
    std.testing.expect(tok7.*.tokenType == TokenType.EqualsToken);

    var tok8 = try iter.next();
    std.testing.expect(tok8.*.tokenType == TokenType.ValueToken);

    var tok9 = try iter.next();
    std.testing.expect(tok9.*.tokenType == TokenType.ReturnToken);

    var tok10 = try iter.next();
    std.testing.expect(tok10.*.tokenType == TokenType.IdentifierToken);

    var tok11 = try iter.next();
    std.testing.expect(tok11.*.tokenType == TokenType.EndToken);
}

//
// // ==========================
// //   INTERNALS
// // ==========================
//
// /// Get the next token in this file
// ///
// /// return, token or a lexer error
// fn getNextToken(self: *Self) LexerError!Token {
//     // Trim indentation
//     self.trimLeft();
//
//     // Ignore comments
//     while (self.isNotEmpty() and self.source[self.pos] == COMMENT_SYMBOL) {
//         self.dropLine();
//         self.trimLeft();
//     }
//
//     var token = Token{};
//     // TODO: not assigning correct type here
//     token.location = self.cur;
//
//     if (self.empty()) return false;
//
//     var loc = self.cur;
//
//     // Get characters while they're alphanum
//     if (std.ascii.isAlphanumeric(self.source)) {
//         var idx = self.pos;
//
//         while (self.isNotEmpty() and std.ascii.isAlphanumeric(self.source(self.pos))) {
//             self.chopChar();
//         }
//
//         // First tokenizer
//         return Token.init(loc, "TOKENNAME", self.source[idx..self.cursor]);
//     }
// }
//
// /// Check that cursor is not totally out
// fn isNotEmpty(self: *Self) bool {
//     return self.pos < self.source.len;
// }
//
// // TODO: Implement
// fn trimLeft(self: *Self) void {
//     _ = self;
//     //while (self.isNotEmpty() and isSpace(self.source[self.pos])) {
//     //    self.chopChar();
//     //}
// }
//
// /// "Chops" off characters
// fn chopChar(self: *Self) void {
//     if (self.isNotEmpty()) {
//         var x = self.source[self.pos];
//         self.pos += 1;
//
//         // We are now at the next line
//         if (std.ascii.isWhitespace(x)) {
//             self.bol = self.pos;
//             self.row += 1;
//         }
//     }
// }
