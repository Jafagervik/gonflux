const std = @import("std");

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
    pub fn init(tt: TokenType, loc: Location, value: []const u8) Token {
        return Token{ .location = loc, .tokenType = tt, .lexeme = value };
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
    pub fn tokenize(self: Self) (LexerError!anyerror)![]Token {
        // Set up allocator

        var tokenList = std.ArrayList(Token).init(std.testing.allocator);

        // Remove every space or newline at the beginning
        self.trimStart();

        // While we're not at the end of the file and can get a character
        while (self.peek()) : (self.cursor += 1) {

            // Move until we actually get what we want
            self.chopSpace();

            var c = self.data[self.cursor];

            // We are now looking at first token in a lexeme
            switch (c) {
                // Single line comment
                '/' and self.peek() == '/' => {
                    self.chopUntilNextLine();
                },

                // If we get to a new line, we should update BOL and cursor
                '\n' => {
                    self.row += 1;
                    self.cursor += 1;
                    self.beginning_of_line = self.cursor;
                },

                // BRACKETS
                '[' => try tokenList.push(self.initToken(TokenType.OperatorToken.BRACEOPEN, "[")),
                ']' => try tokenList.push(self.initToken(TokenType.OperatorToken.BRACEOPEN, "]")),
                '(' => try tokenList.push(self.initToken(TokenType.OperatorToken.PARENOPEN, "(")),
                ')' => try tokenList.push(self.initToken(TokenType.OperatorToken.PARENCLOSE, ")")),
                '{' => try tokenList.push(self.initToken(TokenType.OperatorToken.BRACKOPEN, "{")),
                '}' => try tokenList.push(self.initToken(TokenType.OperatorToken.BRACKOPEN, "}")),
                // OPERATORS or ASSIGNMENTS

                '+' => {
                    switch (self.peek()) {
                        '+' => try tokenList.push(self.initToken(TokenType.SpecialToken.PLUSPLUS, "++")),
                        '=' => try tokenList.push(self.initToken(TokenType.AssignmentToken, "+=")),
                        ' ' => try tokenList.push(self.initToken(TokenType.OperatorToken.PLUS, "+")),
                    }
                },

                '-' => {
                    switch (self.peek()) {
                        '=' => try tokenList.push(self.initToken(TokenType.AssignmentToken, "-=")),
                        ' ' => try tokenList.push(self.initToken(TokenType.OperatorToken.PLUS, "-")),
                    }
                },

                // Digit
                std.ascii.isDigit(c) => {},

                // Letter
                std.ascii.isAlphabetic(c) => {
                    const lexeme = self.getLexeme();
                    const jump: usize = lexeme.len;

                    self.cursor += jump;
                },

                // Escape chars

                // We should not be able to reach here
                _ => LexerError.UnrecognizableCharacter,
            }
        }

        for (self.tokenList.items) |token| {
            token.print();
        }

        // ======= END OF LOOP ================

        // var loc: Location = Location.init(payload, 42, 42);
        // var t: Token = Token.init(loc, TokenType.ARROW, "hello");

        // TODO: Remember to free this after they have been used
        return tokenList.toOwnedSlice();
    }

    /// Peeks one char ahead in the future
    ///
    /// returns either a char or null if not
    fn peek(self: Self) u8 {
        return self.data[self.cursor + 1];
    }

    // TODO: This is probably bad practise.
    /// Peeks n ahead in the future and could return a string slice
    fn peekN(self: Self, n: usize) ?[]u8 {
        return self.data[self.cursor .. self.cursor + n] orelse null;
    }

    // TODO: Check if logic checks out here
    /// Will look ahead and try to get the next string.
    /// Will either return a slize, or a null i
    fn getLexeme(self: Self) ?[]u8 {
        var look_ahead: usize = 0;

        while (self.data[self.cursor + look_ahead] and
            !self.isSpace(self.data[self.cursor + look_ahead])) : (look_ahead += 1)
        {}

        return self.data[self.cursor .. self.cursor + look_ahead] orelse null;
    }

    /// Since we found a comment, skip until next line
    fn chopUntilNextLine(self: Self) void {
        while (self.data[self.cursor] != '\n') : (self.cursor += 1) {}

        self.row += 1;
        self.beginning_of_line = self.cursor;
    }

    /// Moves the cursor until we get to the next token
    fn chopSpace(self: Self) void {
        while (self.data[self.cursor] == ' ') : (self.cursor += 1) {}
    }

    /// Clean up the start until we hit a character
    fn trimStart(self: Self) void {
        if (self.data[self.cursor] == ' ') {
            self.cursor += 1;
            self.trimStart();
        } else if (self.data[self.cursor] == '\n') {
            self.cursor += 1;
            self.row += 1;
            self.beginning_of_line = self.cursor;
            self.trimStart();
        } else {
            return;
        }
    }

    /// Helper function to init a token
    /// initToken(TYPE, LEXEME)
    /// lexeme should be a slice
    fn initToken(self: Self, tt: TokenType, lexeme: []u8) Token {
        // Col = cur - bol
        var location = Location.init(self.file_path, self.row, self.cursor - self.beginning_of_line);
        return Token.init(tt, location, lexeme);
    }

    // =====================
    //   Helpers
    // =====================

    /// Check whether or not a given char is
    /// space, new_line or tab
    ///
    /// See doc for what is counted as space
    fn isSpace(c: u8) bool {
        return std.ascii.isWhitespace(c);
    }

    /// Lexer helper
    ///
    /// Checks that a character is a sy
    fn isSymbol(c: u8) bool {
        return !std.ascii.isAlphanumeric(c) and !isEscapeCharacter(c);
    }

    /// Lexer helper
    ///
    /// Will check for escape character
    fn isEscapeCharacter(c: u8) bool {
        return c == '\n' or c == '\'' or c == '\"' or c == '\n' or c == '\r' or c == '\t' or c == '\\';
    }

    /// Check up valid datatypes
    ///
    /// A lot of early returns to easily discard value
    fn isValidDatatype(s: []u8) bool {
        const n = s.len;
        if (n > 4 or n < 2) return false;

        if (!(s[0] == 'u' or s[0] == 'i' or s[0] == 'f')) return false;

        if (!(s[1] == '1' or s[1] == '3' or s[1] == '6' or s[1] == '8')) return false;

        // We should not access this code if we're this far
        if (n < 3) return false;

        if (!(s[2] == '2' or s[1] == '4' or s[2] == '6')) return false;

        if (n < 4) return false;

        if (!s[3] == '8') return false;

        return true;
    }
};

// =========================
//     TESTS FOR LEXER
// =========================
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
    std.testing.expect(tok1.*.tokenType == TokenType.KeywordToken.FN);

    var tok2 = try iter.next();
    std.testing.expect(tok2.*.tokenType == TokenType.LiteralToken.IDENTIFIER);

    var tok3 = try iter.next();
    std.testing.expect(tok3.*.tokenType == TokenType.OperatorToken.PARENOPEN);

    var tok4 = try iter.next();
    std.testing.expect(tok4.*.tokenType == TokenType.OperatorToken.PARENCLOSE);

    var tok5 = try iter.next();
    std.testing.expect(tok5.*.tokenType == TokenType.SpecialToken.ARROW);

    var tok6 = try iter.next();
    std.testing.expect(tok6.*.tokenType == TokenType.LiteralToken.IDENTIFIER);

    var tok7 = try iter.next();
    std.testing.expect(tok7.*.tokenType == TokenType.AssignmentToken.EQUAL);

    var tok8 = try iter.next();
    std.testing.expect(tok8.*.tokenType == TokenType.LiteralToken.I32);

    var tok9 = try iter.next();
    std.testing.expect(tok9.*.tokenType == TokenType.ReturnToken);

    var tok10 = try iter.next();
    std.testing.expect(tok10.*.tokenType == TokenType.IdentifierToken);

    var tok11 = try iter.next();
    std.testing.expect(tok11.*.tokenType == TokenType.EndToken);
}
