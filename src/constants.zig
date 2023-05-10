/// Symbol used for marking comments
pub const COMMENT_SYMBOL = "//";

/// Terminal display name
pub const GFLX: []const u8 =
    \\
    \\   ============  =========== ==         ==         ==
    \\   ============  =========== ==          ==       ==
    \\   ==            ==          ==           ==     ==
    \\   ==            ==          ==            ==   ==
    \\   ============= =========== ==             == ==
    \\   ============= =========== ==              === 
    \\   ==         == ==          ==             == ==
    \\   ==         == ==          ==            ==   ==
    \\   ============= ==          ==========   ==     ==
    \\   ============= ==          ==========  ==       ==
    \\ 
;
/// Debug mode
pub const DEBUG = true;

// Valid filenames
pub const VALID_EXTENSIONS = [_]u8{ ".gflx", ".cugflx" };

/// Valid datatypes
pub const VALID_DATATYPES = [_][]const u8{
    "u8",
    "u16",
    "u32",
    "u64",
    "u128",

    "i8",
    "i16",
    "i32",
    "i64",
    "i128",

    "f8",
    "f16",
    "f32",
    "f64",
    "f128",
};
