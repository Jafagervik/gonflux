const std = @import("std");

/// Check whether or not a given char is
/// space, new_line or tab
///
/// See doc for what is counted as space
pub fn isSpace(c: u8) bool {
    return std.ascii.isWhitespace(c);
}

/// Read file from input line to parse and read from
///
/// filepath: path to entry point
/// allocator: which allocator to use
/// bufsize: Size of buffer to store data in
pub fn readFile(filepath: []const u8, allocator: std.mem.Allocator, bufsize: usize) ![]u8 {
    // Get the path
    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const path = try std.fs.realpath(filepath, &path_buffer);

    // Open the file
    const file = try std.fs.openFileAbsolute(path, .{ .read = true });

    // This has to be moved potentially
    defer file.close();

    // Read the contents
    return try file.readToEndAlloc(allocator, bufsize);
}

/// Subcommands for help menu
const SubCommand = enum { run, help };

/// Print help if any of the noobs should have any issues with parsing
/// SubCommand tells us what mode the user is in at that exact moment
fn printHelp(subcommand: SubCommand) !void {
    const stdout = std.io.getStdOut();

    switch (subcommand) {
        .run => {
            try stdout.writeAll(
                \\Usage: 
                \\    gflx -path -options
                \\
                \\General Options:
                \\
                \\  -file-path [path]     File Path to your program
                \\
                \\Options:
                \\
                \\  --c              Starts a concurrent mode
                \\
                \\
            );
        },
        .help => {
            try stdout.writeAll(
                \\Usage: 
                \\  mach [command]
                \\
                \\Commands:
                \\  run    Run the interpreter
                \\  help   Print this mesage or the help of the given command
                \\
                \\
            );
        },
    }
}

test "enough memory" {
    return true;
}
