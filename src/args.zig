const std = @import("std");

/// Return a struct containing flags and length possibly
pub const ArgsParser = struct {
    const Self = @This();

    length: usize = 0,

    // Rest is flags

    ///
    optLevel: u8 = 1,

    pub fn parse() void {
        var args = std.process.args();
        defer args.deinit();

        _ = args.skip();

        // optLevel

        // Go thorugh arguments and add to list of compilation flags

    }
};
