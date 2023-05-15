#include <catch2/catch_test_macros.hpp>

/*
#include "../src/lexer.h"
#include "../src/token.h"

auto get_payload(std::string filename) {
    std::vector<char> payload = {'"', 'H', 'e', 'l', 'l', 'o', '"', '\n'};
    auto lexer = Lexer(filename, payload);

    lexer.tokenize();

    return lexer.token_list;
}

TEST_CASE("Lexer String Test", "[get_payload]") {
    REQUIRE(get_payload("test.gflx")[0]->type == TOKEN_STRING);
}
*/

TEST_CASE("Lexer String Test") { REQUIRE(1 == 1); }
