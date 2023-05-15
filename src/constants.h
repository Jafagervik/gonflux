#pragma once

#include <iostream>
#include <map>
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
