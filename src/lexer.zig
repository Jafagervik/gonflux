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
    data: []const u8 = undefined,

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
    pub fn init(file_path: []const u8, payload: []const u8) Lexer {
        return Lexer{ .file_path = file_path, .data = payload };
    }

    /// Tokenizes source file and returns an iterator
    /// we can use to parse for
    ///
    /// Returns: Pointer to token iterator or LexerError
    pub fn tokenize(self: *Self) ![]Token {
        // Set up allocator
        var buffer: [5000]u8 = undefined;
        var fba = std.heap.FixedBufferAllocator.init(&buffer);
        const allocator = fba.allocator();

        var tokenList = std.ArrayList(Token).init(allocator);

        // Remove every space or newline at the beginning
        self.trimStart();

        // While we're not at the end of the file and can get a character
        while (!self.endOfFile()) : (self.cursor += 1) {
            std.debug.print("C start: {c}\n", .{self.data[self.cursor]});

            // Move until we actually get what we want
            self.chopSpace();

            var c = self.data[self.cursor];

            std.debug.print("C got here: {c}\n", .{c});

            // We are now looking at first token in a lexeme
            switch (c) {
                // We begin with all kinds of symbols in this switch

                // TODO: Check if we need to add newline as a token
                // If we get to a new line, we should update BOL and cursor
                // Cursor gets updated in loop, so only upadte row and bol
                '\n' => {
                    self.row += 1;
                    self.beginning_of_line = self.cursor + 1;
                },

                // Quotes for strings and characters
                '\'' => try tokenList.append(self.initToken(TokenType.QUOTE, "\'")),
                '\"' => try tokenList.append(self.initToken(TokenType.DOUBLEQUOTE, "\"")),

                // Can both be used for pattern matching and as part of
                '_' => {
                    if (self.peek() == ' ') {
                        try tokenList.append(self.initToken(TokenType.UNDERSCORE, "_"));
                        self.cursor += 1;
                    }
                },

                // List concat
                ':' => {
                    if (self.peek() == ':') {
                        try tokenList.append(self.initToken(TokenType.COLONCOLON, "::"));
                        self.cursor += 1;
                    } else {
                        try tokenList.append(self.initToken(TokenType.COLON, ":"));
                    }
                },

                // BRACKETS
                '(' => try tokenList.append(self.initToken(TokenType.PARENTOPEN, "(")),
                ')' => try tokenList.append(self.initToken(TokenType.PARENTCLOSE, ")")),
                '[' => try tokenList.append(self.initToken(TokenType.BRACEOPEN, "[")),
                ']' => try tokenList.append(self.initToken(TokenType.BRACEOPEN, "]")),
                '{' => try tokenList.append(self.initToken(TokenType.BRACKETOPEN, "{")),
                '}' => try tokenList.append(self.initToken(TokenType.BRACKETCLOSE, "}")),
                // OPERATORS or ASSIGNMENTS

                '+' => {
                    switch (self.peek()) {
                        '+' => {
                            try tokenList.append(self.initToken(TokenType.PLUSPLUS, "++"));
                            self.cursor += 1;
                        },
                        '=' => {
                            try tokenList.append(self.initToken(TokenType.PLUSEQUAL, "+="));
                            self.cursor += 1;
                        },
                        ' ' => try tokenList.append(self.initToken(TokenType.PLUS, "+")),
                        else => unreachable,
                    }
                },

                '-' => {
                    switch (self.peek()) {
                        '=' => {
                            try tokenList.append(self.initToken(TokenType.MINUSEQUAL, "-="));
                            self.cursor += 1;
                        },
                        ' ' => try tokenList.append(self.initToken(TokenType.MINUS, "-")),
                        else => unreachable,
                    }
                },

                // TODO: Dereferencing when it comes to pointers need to be held in mind
                '*' => {
                    switch (self.peek()) {
                        '=' => {
                            try tokenList.append(self.initToken(TokenType.ASTERISKEQUAL, "*="));
                            self.cursor += 1;
                        },
                        ' ' => try tokenList.append(self.initToken(TokenType.ASTERISK, "*")),
                        else => unreachable,
                    }
                },

                '/' => {
                    switch (self.peek()) {
                        // SINGLE LINE COMMMENT
                        '/' => {
                            //try tokenList.append(self.initToken(TokenType., "/"));
                            self.chopUntilNextLine();
                        },
                        '=' => {
                            try tokenList.append(self.initToken(TokenType.DIVIDEEQUAL, "/="));
                            self.cursor += 1;
                        },
                        ' ' => try tokenList.append(self.initToken(TokenType.DIVIDE, "/")),
                        else => unreachable,
                    }
                },

                // ======================
                // BIT OPERATIONS
                // ======================

                // FIXME: This could also be a reference, but this is for the parser to decide
                '&' => {
                    switch (self.peek()) {
                        '=' => {
                            try tokenList.append(self.initToken(TokenType.BITANDEQUAL, "&="));
                            self.cursor += 1;
                        },
                        // Reference and logical and for bits
                        ' ' => try tokenList.append(self.initToken(TokenType.ANDPERCEN, "&")),
                        else => undefined,
                    }
                },

                // Pipe can mean either a capture list or bit or
                '|' => {
                    switch (self.peek()) {
                        '=' => {
                            try tokenList.append(self.initToken(TokenType.BITOREQUAL, "|="));
                            self.cursor += 1;
                        },
                        // Reference and logical and for bits
                        ' ' => try tokenList.append(self.initToken(TokenType.PIPE, "|")),
                        else => unreachable,
                    }
                },

                '^' => {
                    switch (self.peek()) {
                        '=' => {
                            try tokenList.append(self.initToken(TokenType.BITXOREQUAL, "^="));
                            self.cursor += 1;
                        },
                        // Reference and logical and for bits
                        ' ' => try tokenList.append(self.initToken(TokenType.BITXOR, "^")),
                        else => unreachable,
                    }
                },

                '~' => {
                    switch (self.peek()) {
                        '=' => {
                            try tokenList.append(self.initToken(TokenType.BITNOTEQUAL, "~="));
                            self.cursor += 1;
                        },
                        // Reference and logical and for bits
                        ' ' => try tokenList.append(self.initToken(TokenType.BITNOT, "~")),
                        else => unreachable,
                    }
                },

                // If they are none of the afformentioned, it has to be string or digit, or escape char
                else => {
                    std.debug.print("C got inside right place: {c}\n", .{c});
                    const lexeme = self.getLexeme();

                    std.debug.print("Lexeme: {s}\n", .{lexeme});
                    const jump: usize = lexeme.len;

                    // Used as identifier
                    if (c == '_' and std.ascii.isAlphanumeric(self.peek())) {
                        // _Identfier
                        try tokenList.append(self.initToken(TokenType.IDENTIFIER, lexeme));
                    }
                    // Digit
                    // NOTE: Here we have to be careful that we could both have integer and float
                    else if (std.ascii.isDigit(c)) {

                        // Float
                        if (self.containsDot(lexeme)) {
                            try tokenList.append(self.initToken(TokenType.FLOAT, lexeme));
                        } else {
                            try tokenList.append(self.initToken(TokenType.INTEGER, lexeme));
                        }
                    } else if (std.ascii.isAlphabetic(c)) {
                        // =================================================================
                        //                         KEYWORDS
                        // =================================================================
                        // TODO: Optimize this pattern matching perhaps
                        if (std.mem.eql(u8, lexeme, "Pointer")) {
                            try tokenList.append(self.initToken(TokenType.POINTER, "Pointer"));
                        } else if (std.mem.eql(u8, lexeme, "fn")) {
                            try tokenList.append(self.initToken(TokenType.FN, "fn"));
                        } else if (std.mem.eql(u8, lexeme, "atomic")) {
                            try tokenList.append(self.initToken(TokenType.ATOMIC, "atomic"));
                        } else if (std.mem.eql(u8, lexeme, "end")) {
                            try tokenList.append(self.initToken(TokenType.END, "end"));
                        } else if (std.mem.eql(u8, lexeme, "null")) {
                            try tokenList.append(self.initToken(TokenType.NULL, "null"));
                        } else if (std.mem.eql(u8, lexeme, "if")) {
                            try tokenList.append(self.initToken(TokenType.IF, "if"));
                        } else if (std.mem.eql(u8, lexeme, "elseif")) {
                            try tokenList.append(self.initToken(TokenType.ELSEIF, "elseif"));
                        } else if (std.mem.eql(u8, lexeme, "else")) {
                            try tokenList.append(self.initToken(TokenType.ELSE, "else"));
                        } else if (std.mem.eql(u8, lexeme, "then")) {
                            try tokenList.append(self.initToken(TokenType.THEN, "then"));
                        } else if (std.mem.eql(u8, lexeme, "while")) {
                            try tokenList.append(self.initToken(TokenType.WHILE, "while"));
                        } else if (std.mem.eql(u8, lexeme, "for")) {
                            try tokenList.append(self.initToken(TokenType.FOR, "for"));
                        } else if (std.mem.eql(u8, lexeme, "mut")) {
                            try tokenList.append(self.initToken(TokenType.MUT, "mut"));
                        } else if (std.mem.eql(u8, lexeme, "break")) {
                            try tokenList.append(self.initToken(TokenType.BREAK, "break"));
                        } else if (std.mem.eql(u8, lexeme, "continue")) {
                            try tokenList.append(self.initToken(TokenType.CONTINUE, "continue"));
                        } else if (std.mem.eql(u8, lexeme, "return")) {
                            try tokenList.append(self.initToken(TokenType.RETURN, "return"));
                        } else if (std.mem.eql(u8, lexeme, "match")) {
                            try tokenList.append(self.initToken(TokenType.MATCH, "match"));
                        } else if (std.mem.eql(u8, lexeme, "throw")) {
                            try tokenList.append(self.initToken(TokenType.THROW, "throw"));
                        } else if (std.mem.eql(u8, lexeme, "catch")) {
                            try tokenList.append(self.initToken(TokenType.CATCH, "catch"));
                        } else if (std.mem.eql(u8, lexeme, "try")) {
                            try tokenList.append(self.initToken(TokenType.TRY, "try"));
                        } else if (std.mem.eql(u8, lexeme, "import")) {
                            try tokenList.append(self.initToken(TokenType.IMPORT, "import"));
                        } else if (std.mem.eql(u8, lexeme, "export")) {
                            try tokenList.append(self.initToken(TokenType.EXPORT, "export"));
                        } else if (std.mem.eql(u8, lexeme, "public")) {
                            try tokenList.append(self.initToken(TokenType.PUBLIC, "public"));
                        } else if (std.mem.eql(u8, lexeme, "inline")) {
                            try tokenList.append(self.initToken(TokenType.INLINE, "inline"));
                        } else if (std.mem.eql(u8, lexeme, "typeof")) {
                            try tokenList.append(self.initToken(TokenType.TYPEOF, "typeof"));
                        } else if (std.mem.eql(u8, lexeme, "type")) {
                            try tokenList.append(self.initToken(TokenType.TYPE, "type"));
                        } else if (std.mem.eql(u8, lexeme, "enum")) {
                            try tokenList.append(self.initToken(TokenType.ENUM, "enum"));
                        } else if (std.mem.eql(u8, lexeme, "struct")) {
                            try tokenList.append(self.initToken(TokenType.STRUCT, "struct"));
                        } else if (std.mem.eql(u8, lexeme, "in")) {
                            try tokenList.append(self.initToken(TokenType.IN, "in"));
                            // =====================================================================
                            //                     END OF KEYWORDS
                            // =====================================================================
                        } else {

                            // Lexeme didn't match against any of the keywords
                            // Then it has to be an identifier or a datatype
                            // TODO: Limit what identifiers can be used

                            try tokenList.append(self.initToken(TokenType.IDENTIFIER, lexeme));
                        }
                    }

                    // We did not find any meaningful character in this section
                    // This should not be reachable
                    else {
                        unreachable;
                        //return LexerError.UnrecognizableCharacter;
                    }

                    // FIXME: Since cursor jumps anyways, maybe jump one less
                    // No matter what we get, we jump ahead
                    self.cursor += jump;
                },

                // TODO: Escape chars

            }
        }
        // ======= END OF LOOP ================

        for (tokenList.items) |token| {
            token.print();
        }

        // TODO: Remember to free this after they have been used
        return tokenList.toOwnedSlice();
    }

    /// Check if we're at the end of the file
    ///
    /// Checks bounds for cursor and there actually exist data at given position
    fn endOfFile(self: Self) bool {
        // FIXME: For large files, we can't assume we know the length of it all
        return self.cursor >= self.data.len - 1;
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
    fn getLexeme(self: Self) []const u8 {
        var look_ahead: usize = 0;

        while (self.cursor + look_ahead <= self.data.len and
            !self.isSpace(self.data[self.cursor + look_ahead])) : (look_ahead += 1)
        {}

        return self.data[self.cursor .. self.cursor + look_ahead];
    }

    /// Since we found a comment, skip until next line
    fn chopUntilNextLine(self: *Self) void {
        while (self.data[self.cursor] != '\n') : (self.cursor += 1) {}

        self.row += 1;
        self.beginning_of_line = self.cursor;
    }

    /// Moves the cursor until we get to the next token
    fn chopSpace(self: *Self) void {
        while (self.data[self.cursor] == ' ') : (self.cursor += 1) {}
    }

    /// Clean up the start until we hit a character
    fn trimStart(self: *Self) void {
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
    fn initToken(self: Self, tt: TokenType, lexeme: []const u8) Token {
        // Col = cur - bol
        var location = Location.init(self.file_path, self.row, self.cursor - self.beginning_of_line);
        return Token.init(tt, location, lexeme);
    }

    // TODO: Find out if this is a correct way to think about scanning of floats
    /// Check if a lexeme contains a dot or not
    /// This way we can indicate further down that this is a float
    fn containsDot(self: Self, lexeme: []const u8) bool {
        _ = self;
        return for (lexeme) |c| {
            if (c == '.') break true;
        } else false;
    }

    // =====================
    //   Helpers
    // =====================

    /// Check whether or not a given char is
    /// space, new_line or tab
    ///
    /// See doc for what is counted as space
    fn isSpace(self: Self, c: u8) bool {
        _ = self;
        return std.ascii.isWhitespace(c);
    }

    /// Lexer helper
    ///
    /// Checks that a character is a sy
    fn isSymbol(self: Self, c: u8) bool {
        return !std.ascii.isAlphanumeric(c) and !self.isEscapeCharacter(c);
    }

    /// Lexer helper
    ///
    /// Will check for escape character
    fn isEscapeCharacter(self: Self, c: u8) bool {
        _ = self;
        return c == '\n' or c == '\'' or c == '\"' or c == '\n' or c == '\r' or c == '\t' or c == '\\';
    }

    /// Check up valid datatypes
    ///
    /// A lot of early returns to easily discard value
    fn isValidDatatype(self: Self, s: []const u8) bool {
        _ = self;

        return for (Constants.VALID_DATATYPES) |dt| {
            if (std.mem.eql(u8, s, dt))
                break true;
        } else false;
    }
};

// =========================
//     TESTS FOR Lexer
// =========================
test "docs" {
    std.testing.refAllDecls(Lexer);
}

test "helpers" {
    var l = Lexer{};
    // float
    try std.testing.expectEqual(true, l.containsDot("123.123"));
    try std.testing.expectEqual(true, l.isSpace(' '));
    try std.testing.expectEqual(true, l.isSymbol(']'));
    try std.testing.expectEqual(true, l.isValidDatatype("u8"));
    try std.testing.expectEqual(true, l.isValidDatatype("u16"));
    try std.testing.expectEqual(true, l.isValidDatatype("u32"));
    try std.testing.expectEqual(true, l.isValidDatatype("u64"));
    try std.testing.expectEqual(true, l.isValidDatatype("u128"));
    try std.testing.expectEqual(true, l.isValidDatatype("i8"));
    try std.testing.expectEqual(true, l.isValidDatatype("i64"));
    try std.testing.expectEqual(true, l.isValidDatatype("f128"));
    try std.testing.expectEqual(true, l.isValidDatatype("f16"));
    try std.testing.expectEqual(false, l.isValidDatatype("f420"));
}

test "Simple lexing" {
    const data: []const u8 =
        \\fn main() ->
        \\end
    ;

    var scanner = Lexer.init("./test.gflx", data);
    var lst = try scanner.tokenize();

    var tok1 = lst[0];
    tok1.print();
    try std.testing.expectEqual(tok1.tokenType, TokenType.FN);
}

// test "lexical analysis" {
//     const data: []const u8 =
//         \\fn main() ->
//         \\    a: i32 = 1 + 2
//         \\    b: i32 = a * 4
//         \\    name = "Hello!"
//         \\end
//     ;
//
//     var scanner = Lexer.init("./test.gflx", data);
//     var iter = scanner.tokenize();
//
//     var tok1 = try iter.next();
//     std.testing.expect(tok1.*.tokenType == TokenType.FN);
//
//     var tok2 = try iter.next();
//     std.testing.expect(tok2.*.tokenType == TokenType.LiteralToken.IDENTIFIER);
//
//     var tok3 = try iter.next();
//     std.testing.expect(tok3.*.tokenType == TokenType.OperatorToken.PARENOPEN);
//
//     var tok4 = try iter.next();
//     std.testing.expect(tok4.*.tokenType == TokenType.OperatorToken.PARENCLOSE);
//
//     var tok5 = try iter.next();
//     std.testing.expect(tok5.*.tokenType == TokenType.SpecialToken.ARROW);
//
//     var tok6 = try iter.next();
//     std.testing.expect(tok6.*.tokenType == TokenType.LiteralToken.IDENTIFIER);
//
//     var tok7 = try iter.next();
//     std.testing.expect(tok7.*.tokenType == TokenType.AssignmentToken.EQUAL);
//
//     var tok8 = try iter.next();
//     std.testing.expect(tok8.*.tokenType == TokenType.LiteralToken.I32);
//
//     var tok9 = try iter.next();
//     std.testing.expect(tok9.*.tokenType == TokenType.ReturnToken);
//
//     var tok10 = try iter.next();
//     std.testing.expect(tok10.*.tokenType == TokenType.IdentifierToken);
//
//     var tok11 = try iter.next();
//     std.testing.expect(tok11.*.tokenType == TokenType.EndToken);
// }
