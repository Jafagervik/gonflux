const err = @import("./types/error.zig");

//pub const OrFullErr = err.OrFullErr;

test "types" {
    _ = @import("./types/error.zig");
}

test "docs" {
    @import("std").testing.refAllDecls(@This());
}
