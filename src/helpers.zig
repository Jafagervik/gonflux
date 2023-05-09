const std = @import("std");

pub fn print(val: anytype) void {
    std.debug.print("{any}\n", .{val});
}

pub fn prints(val: anytype) void {
    std.debug.print("{s}\n", .{val});
}

/// ArrayList Buffer
pub fn getAllocatorArrayList() std.heap.Allocator {
    const token_buffer_size: usize = std.math.maxInt(usize);
    // Buffer for the array list containing the tokens
    var buffer: [token_buffer_size]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    return fba.allocator();
}

/// Read file from input line to parse and read from
///
/// filepath: path to entry point
/// allocator: which allocator to use
/// bufsize: Size of buffer to store data in
pub fn readFile(filepath: []const u8, bufsize: usize, allocator: *const std.mem.Allocator) ![]u8 {
    // Get the path
    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const path = try std.fs.realpath(filepath, &path_buffer);

    // Open the file
    const file = try std.fs.openFileAbsolute(path, .{});

    @compileLog("Im here\n");

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
            );
        },
        .help => {
            try stdout.writeAll(
                \\Usage: 
                \\  mach [command]
                \\
                \\Commands:
                \\  build  Build an executable
                \\  run    Run an executable 
                \\  help   Print this mesage or the help of the given command
                \\
                \\
                \\Example
                \\    zig build run - will run src/main.gflx
            );
        },
    }
}

test "enough memory" {
    return true;
}
