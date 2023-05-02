const std = @import("std");

/// TODO: Improve
const lexererr = @import("errors").LexerErrors;

/// Representation of a token in this magnificent language
const Token = struct {
    /// Token type
    type: TokenType,
    /// Text representation
    text: []const u8,
    /// Position in the line it occurs
    pos: usize,
};

/// Full list of all supported TokenTypes
///
/// PLUS,
/// MINUS,
/// MULT,
/// DIV,
/// MOD,
/// BOOL,
/// GT,
/// LT,
/// EQ,
/// NEQ,
/// GEQ,
/// LEQ,
/// END,
/// ARROW,
/// MATCH,
/// LAMBDA \x,y -> x + y end
/// IDENT
/// NUMBER
/// STRING
/// CHAR
pub const TokenType = enum { OperatorToken, IDENT, BOOL, FUN, MATCH, PROC, END, EOF, STRING, CHAR, ARROW, MATCH, COMMENT };

/// Operator Token
pub const OperatorToken = enum { PLUS, MINUS, MULT, DIV, GT, LT, EQ, NEQ, GEQ, LEQ, MOD };

/// This function goes through all the text from the file,
/// and then tokenizes the input
pub const Lexer = struct {
    const Self = @This();

    // Current position in file
    pos: usize,

    pub fn tokenize(file: std.fs.File) anyerror![]Token {
        var token_list = std.ArrayList(Token).init();

        // Walk through file line by next_line
        // TODO: In practise, yield for new line
        while (try next_line(file)) |line| {

            // Walk by char by char
            while (try get_char(line)) |char| {
                switch (char) {
                    'a' => undefined,
                    'e' => undefined,
                }
            }
        }

        // Next step is to parse this token list
        return token_list;
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

    fn get_char(line: [:0]u8) void {
        var idx: usize = 0;

        for (line) {

        }


    }
};

test "docs" {
    std.testing.refAllDecls(Lexer);
}
