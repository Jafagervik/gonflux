const std = @import("std");
const builtin = @import("builtin");

const errors = @import("errors");
const helpers = @import("helpers.zig");

const Interpreter = @import("interpreter.zig").Interpreter;

var args: []const [:0]u8 = undefined;
var arg_i: usize = 1;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
pub const allocator = gpa.allocator();

/// Length of file extension
const EXT_LEN = 5;

/// Main idea at the start is to create a simple interpreter that is capable
/// of doing the most basic of tasks
pub fn main() anyerror!void {
    defer _ = gpa.deinit();

    // Handle arguments
    args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    // Way too few arguments
    if (args.len == 1) {
        std.log.err("Oops, too few arguments!\n");
        std.os.exit(1);
    }

    // Check that file extension is correct
    if (!std.mem.eql(u8, args[arg_i][args.len - EXT_LEN .. args.len], ".gflx")) {
        std.log.err("Incorrect file extension. Are you sure your extension is '.gflx'?\n");
        std.os.exit(1);
    }

    // Check that the file exists at all
    const filename = std.os.getcwd() ++ "/" ++ args[arg_i];
    // TODO: Change code to check if file exists or not
    if (std.fs.openFileAbsolute(filename)) {
        std.log.err("Could not find target file. Tried to run:\n\t{}", .{});
        std.os.exit(1);
    }

    // Note: Change this to possibly compile later on?
    // Run the interpreter

    Interpreter.build(filename).run();
}
