#pragma once

#include "token.h"
#include <iostream>
#include <string>
#include <unordered_map>
#include <unordered_set>

// Version
static constexpr auto MAJOR = 0;
static constexpr auto MINOR = 0;
static constexpr auto LEVEL = 1;

static constexpr auto NAME = R"(
    ============  =========== ==         ==         ==
    ============  =========== ==          ==       ==
    ==            ==          ==           ==     ==
    ==            ==          ==            ==   ==
    ============= =========== ==             == ==
    ============= =========== ==              === 
    ==         == ==          ==             == ==
    ==         == ==          ==            ==   ==
    ============= ==          ==========   ==     ==
    ============= ==          ==========  ==       ==
)";

[[maybe_unused]] static const std::unordered_set<std::string> ALL_DATATYPES = {
    "u8",   "u16", "u32", "u64", "u128", "i8",   "i16", "i32",  "i64",
    "i128", "f8",  "f16", "f32", "f64",  "f128", "str", "char", "bool"};

const static std::unordered_map<std::string, TokenType> keywords = {
    {"if", TOKEN_IF},
    {"then", TOKEN_THEN},
    {"while", TOKEN_WHILE},
    {"elseif", TOKEN_ELSEIF},
    {"else", TOKEN_ELSE},
    {"struct", TOKEN_STRUCT},
    {"enum", TOKEN_ENUM},
    {"return", TOKEN_RETURN},
    {"end", TOKEN_END},
    {"export", TOKEN_EXPORT},
    {"null", TOKEN_NULL},
    {"in", TOKEN_IN},
    {"throw", TOKEN_THROW},
    {"type", TOKEN_TYPE},
    {"try", TOKEN_TRY},
    {"typeof", TOKEN_TYPEOF},
    {"continue", TOKEN_CONTINUE},
    {"break", TOKEN_BREAK},
    {"catch", TOKEN_CATCH},
    {"mut", TOKEN_MUT},
    {"compiletime", TOKEN_COMPILETIME},
    {"atomic", TOKEN_ATOMIC},
    {"volatile", TOKEN_VOLATILE}};

/**
 * NOTE: These will start with @ before them
 * TODO: Find out if we do need to store the words if we store individual
 * tokens anyways
 */
const static std::unordered_map<std::string, TokenType> builtin_keywords = {
    {"import", TOKEN_IMPORT}, {"parallel", TOKEN_PARALLEL}};

const static std::unordered_set<std::string> supported_number_datatypes = {
    "u8",  "u16",  "u32", "u64", "u128", "i8",  "i16", "i32",
    "i64", "i128", "f8",  "f16", "f32",  "f64", "f128"};

static constexpr auto MENU =
    R"(GonFLUX -- Beacuse NVIDIA doesnt support FOSS

        Usage:
            flux compile <file>
            flux run <file>
            flux test 
            flux --version 

        Options:
            -h --help      Show this screen.
            -v --version   Show version
            -t --target    Which target to build for 
            -o --opt       Optimization level
)";
