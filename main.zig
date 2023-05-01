const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    // const stdout = std.io.getStdOut().writer();
    //try stdout.print("Hello {s}!\n", .{"world"});
    print("Hello {s}!\n", .{"world"});
}
