#pragma once

#include <array>
#include <cstddef>
#include <iostream>
#include "pch.h"
#include "constants.h"
#include <string_view>
#include <vector>
#include <string>
#include <algorithm>

typedef enum Target { X8664, RISCV, NVIDIA, R7000 } Target;

typedef enum ReturnCode {
    Success = 0,
    FileNotFound,
    EndOfFile,
    TokenError,
    IncompatibleExtension
} ReturnCode;

typedef struct ArgsParser {
        // List of default arguments
        std::string optimize = "-o2";
        Target target = X8664;
        std::string filename;

        ArgsParser(int argc, char *argv[]) : argc(argc) {
            this->args = std::vector<std::string>(argv, argv + argc);
        }

        void printHelper() { std::cout << MENU << "\n"; };

        u32 parse_args() {
            if (argc < 2)
                std::cout << "Too few arguments\n";

            for (const auto &option : args) {
                if (option == "--help" || option == "-h")
                    printHelper();
            }

            // Don't allow weird symbols in filenames either
            auto accepted_filenames = [](const char c) {
                return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'z') ||
                       (c >= 'A' && c <= 'Z') || c == '_';
            };

            this->filename = args[1];
            auto extension = this->filename.substr(this->filename.size() - 5);

            if (extension != ".gflx")
                return IncompatibleExtension;

            return Success;
        }

        u32 argc;
        std::vector<std::string> args;
} ArgsParser;
