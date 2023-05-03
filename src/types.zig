const err = @import("./types/error.zig");
const tokens = @import("./types/tokens.zig");

//pub const OrFullErr = err.OrFullErr;
pub const TokenType = tokens.TokenType;

test "types" {
    _ = @import("./types/error.zig");
}

test "docs" {
    @import("std").testing.refAllDecls(@This());
}
