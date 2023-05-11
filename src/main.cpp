#include "constants.h"
#include "file.h"
#include "lexer.h"
#include "parser.h"
#include <algorithm>
#include <fstream>
#include <iostream>
#include <string_view>
#include <utility>
#include <vector>
#include "pch.h"
#include "timer.h"

typedef enum ReturnCode {
    Success = 0,
    FileNotFound,
    EndOfFile,
    TokenError,
    IncompatibleExtension
} ReturnCode;

int main(int argc, char *argv[]) {
    if (argc < 2)
        std::cout << "Too few arguments\n";

    const std::vector<std::string_view> args(argv + 1, argv + argc);

    for (const auto &option : args) {
        if (option == "--help" || option == "-h")
            std::cout << MENU;
    }

    // Don't allow weird symbols in filenames either
    auto accepted_filenames = [](const char c) {
        return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'z') ||
               (c >= 'A' && c <= 'Z') || c == '_';
    };

    // FIXME: Not safe to let anyone run whatever they want
    char *filename = argv[1];

    std::string_view fn = filename;
    auto extension = fn.substr(fn.size() - 5);

    if (extension != ".gflx")
        return IncompatibleExtension;

    // std::for_each(filename.begin(), filename.end() - 5, accepted_filenames);

    std::ifstream file(filename, std::ios::binary);

    std::vector<char> payload;

    fill_byte_buffer(&payload, &file);

    std::cout << "Number of chars: " << payload.size() << "\n\n";

    std::for_each(payload.begin(), payload.end(),
                  [](const char &c) { std::cout << c << ""; });

    auto lexer = Lexer(filename, payload);

    TIMER(lexer.tokenize);

    std::cout << "\nTIME: " << dur << "s\n";

    std::cout << "Size of tokenlist: " << lexer.token_list.size() << "\n";

    // TODO: Tokenlist should be turned into iterator

    // std::for_each(lexer.token_list.begin(), lexer.token_list.end(),
    //               [](const auto &t) { std::cout << *t << ' '; });

    file.close();

    return Success;
}
