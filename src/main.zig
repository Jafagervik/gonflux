const std = @import("std");
//const fs = std.fs;
//const dir: fs.Dir = fs.cwd();

const interpreter = @import("interpreter");
const parser = @import("parser");
const lexer = @import("lexer");
const errors = @import("errors");

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

var args: []const [:0]u8 = undefined;
var arg_i: usize = 1;

// TODO: Find out what's going on here
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
pub const allocator = gpa.allocator();

/// Main idea at the start is to create a simple interpreter that is capable
/// of doing the most basic of tasks
/// TODO: Maybe switch anyerror with our error
pub fn main() anyerror!void {
    defer _ = gpa.deinit();

    args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    // Way too few arguments
    if (args.len == 1) {
        std.io.getStdOut().writeAll("Oops, too few arguments!");
        return;
    }

    var filename = undefined;
    // TODO: Check if file actually exists and that it ends with .gflx

    const pwd = std.os.getcwd();

    // TODO: Speed this up
    const filepath = pwd ++ filename;

    // Open file for reading
    const f = read_file(filepath);

    // Lex through the input
    const l = lexer.lexer(f);

    // Parse -- AST
    const p = parser.parser(l);

    // Interpret at the end
    const int = interpreter.interpret(p);

    // What we've all been waiting for
    std.debug.print("Result: {}!\n", .{int});
}

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
                \\  -t [threads]     Amount of threads you wanna run
                \\
                \\  -p [processes]   Amount of threads you wanna run
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
