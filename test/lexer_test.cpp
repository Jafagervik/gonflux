#include <catch2/catch_test_macros.hpp>

#include <cstdint>

uint32_t factorial(uint32_t number) {
    return number <= 1 ? number : factorial(number - 1) * number;
}

uint32_t f(uint32_t num) { return num + 5; }

TEST_CASE("Factorials are computed", "[factorial]") {
    REQUIRE(factorial(1) == 1);
    REQUIRE(factorial(2) == 2);
    REQUIRE(factorial(3) == 6);
    REQUIRE(factorial(10) == 3'628'800);
}

TEST_CASE("Testingof tests", "[f]") { REQUIRE(factorial(3) == 10); }
