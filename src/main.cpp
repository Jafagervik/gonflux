#include "constants.h"
#include "file.h"
#include "lexer.h"
#include "parser.h"
#include <algorithm>
#include <fstream>
#include <iostream>
#include <utility>
#include <vector>
#include "pch.h"

typedef enum ReturnCode {
    Success = 0,
    FileNotFound,
    EndOfFile,
    TokenError,
} ReturnCode;

int main(int argc, char *argv[]) {
    if (argc < 2)
        std::cout << "Too few arguments\n";

    // MEME for now
    // std::cout << NAME << std::endl;

    const std::vector<std::string_view> args(argv + 1, argv + argc);

    for (const auto &option : args) {
        if (option == "--help" || option == "-h")
            std::cout << MENU;
    }
    // TODO: MOVE

    char *filename = argv[1];
    std::ifstream file(filename, std::ios::binary);

    std::vector<char> payload;

    fill_byte_buffer(&payload, &file);

    std::cout << payload.size() << std::endl;

    std::for_each(payload.begin(), payload.end(),
                  [](const char &c) { std::cout << c << " "; });

    // Lex
    auto lexer = Lexer(filename, payload);

    lexer.tokenize();

    std::cout << lexer.token_list.size() << std::endl;

    // TODO: Tokenlist should be turned into iterator

    // std::for_each(lexer.token_list.begin(), lexer.token_list.end(), [](const
    // auto &t) {std::cout << *t << ' '; });

    file.close();

    return Success;
}
