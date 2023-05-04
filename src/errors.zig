//! Common errors while parsing

///A bit more specific handling of what kinds of errors could happen when tal
pub const LexerError = error{ GenericError, UnknowTokenError, OtherError };

/// A bit more specific handling of what kinds of errors could happen when tal
pub const ParseError = error{ GenericError, OtherError };

/// A bit more specific handling of what kinds of errors could happen when tal
pub const InterpreterError = error{ GenericError, OtherError };

/// General
pub const GonFLUXError = error{
    LexerError,
    ParseError,
    InterpreterError,
};

test "docs" {
    @import("std").testing.refAllDecls(@This());
}
