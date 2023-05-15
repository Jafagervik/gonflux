#include <algorithm>
#include <fstream>
#include <iostream>
#include <memory>
#include <string_view>
#include <utility>
#include <vector>

#include "args.h"
#include "constants.h"
#include "file.h"
#include "lexer.h"
#include "parser.h"
#include "pch.h"
#include "timer.h"

int main(int argc, char *argv[]) {
    const auto args = std::make_unique<ArgsParser>(ArgsParser(argc, argv));

    u32 status = args->parse_args();
    if (status != 0)
        return status;

    std::cout << args->filename << std::endl;

    std::ifstream file(args->filename, std::ios::binary);

    std::vector<char> payload;

    fill_byte_buffer(&payload, &file);

    // Look at the contents of the file
    // std::for_each(payload.begin(), payload.end(),
    //               [](const char &c) { std::cout << c << ""; });

    auto lexer = Lexer(args->filename, payload);

    TIMER(lexer.tokenize);

    std::cout << "Size of tokenlist: " << lexer.token_list.size() << "\n";

    // TODO: Tokenlist should be turned into iterator

    // std::for_each(lexer.token_list.begin(), lexer.token_list.end(),
    //               [](const auto &t) { std::cout << *t << ' '; });

    file.close();

    return Success;
}
