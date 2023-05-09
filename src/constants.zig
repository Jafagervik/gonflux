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
pub const DEBUG = false;

// Valid filenames
pub const VALID_EXTENSIONS = [_]u8{ ".gflx", ".cugflx" };
