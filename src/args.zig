const std = @import("std");

const ArgumentList = struct {};

pub const ArgsBuilder = struct {
    const Self = @This();
};

const Tag = enum { AST_INTEGER, AST_DECIMAL, AST_STRING, AST_CHAR };

const Data = union {
    const AST_INTEGER = struct {
        number: i32,
    };

    const AST_DECIMAL = struct {
        number: f32,
    };

    const AST_ADD = struct {
        left: ?*AST_ADD,
        right: ?*AST_ADD,
    };

    const AST_SUB = struct {
        left: ?*AST_SUB,
        right: ?*AST_SUB,
    };
};
