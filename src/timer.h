#pragma once

#include <chrono>
#include <iostream>

#define TIMER(X)                                                               \
    std::clock_t start = std::clock();                                         \
    X();                                                                       \
    double dur = static_cast<double>(std::clock() - start) /                   \
                 static_cast<double>(CLOCKS_PER_SEC);                          \
    std::cout << "\nTIME: " << dur << "s\n";
