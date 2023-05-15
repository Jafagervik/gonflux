#include <algorithm>
#include <fstream>
#include <iostream>
#include <memory>
#include <vector>

#include "args.h"
#include "constants.h"
#include "file.h"
#include "lexer.h"
#include "parser.h"
#include "pch.h"
#include "timer.h"

auto main(int argc, char *argv[]) -> int {
    const auto args = std::make_unique<ArgsParser>(ArgsParser(argc, argv));

    u32 status = args->parse_args();
    if (status != 0)
        return status;

    std::cout << args->filename << std::endl;

    std::ifstream file(args->filename);

    if (!file.is_open()) {
        std::cerr << "Failed to open file.\n";
        return FileNotFound;
    }

    // OlD
    // std::vector<char> payload;
    // fill_byte_buffer(&payload, &file);

    // std::for_each(payload.begin(), payload.end(),
    //               [](const char &c) { std::cout << c << ""; });

    auto lexer = std::make_unique<Lexer>(args->filename, &file);

    TIMER(lexer->tokenize);

    // TODO: Find out if or how the lexer is freed
    const auto tokens = std::move(lexer->token_list);

    std::cout << "Size of tokenlist: " << tokens.size() << "\n";

    // std::for_each(tokens.begin(), tokens.end(),
    //               [](const auto &t) { std::cout << *t; });

    file.close();

    return Success;
}
