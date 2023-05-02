const std = @import("std");

/// Read file from input line to parse and read from
/// In the start we want to be able to run basic files
/// But sooner rather than later we want to transform
/// this into a proper build system ZIG can fully take advantage of
fn read_file(filepath: []const u8) void {
    const stdout = std.io.getStdOut();
    const file: std.fs.File = try std.fs.Dir.openFile(
        filepath,
        .{ .read = true },
    );
    defer file.close();

    const reader: std.io.Reader = file.reader();

    // TODO: Buffer need to be larger since we don`t know the
    // sizes we're working with
    var buffer: [5000]u8 = undefined;

    while (reader.readUntilDelimiterOrEof(buffer[0..], '\n')) |line| {
        try stdout.print("Line: {}\n", .{line});
    } else |err| {
        try stdout.print("Error: {}\n", .{err});
    }
}

/// Subcommands for help menu
const SubCommand = enum { run, help };

/// Print help if any of the noobs should have any issues with parsing
/// SubCommand tells us what mode the user is in at that exact moment
fn print_help(subcommand: SubCommand) !void {
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
