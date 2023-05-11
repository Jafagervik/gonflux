# Minimum version
cmake_minimum_required(VERSION 3.25)

if (NOT DEFINED CMAKE_CXX_STANDARD)
    set (CMAKE_CXX_STANDARD 20)
endif()

# Project settings 
project(
    Gonflux
    VERSION 0.1.0
    DESCRIPTION ""
    LANGUAGES CXX 
)

# Using g++ for now
set (CMAKE_CXX_COMPILER /usr/bin/g++)

# look at testing 
if(BUILD_TESTING)
  add_subdirectory(test)
endif()

# Testing 
find_package(Catch2 3 REQUIRED)

# These tests can use the Catch2-provided main
add_executable(tests test/lexer_test.cpp)
target_link_libraries(tests PRIVATE Catch2::Catch2WithMain)

#set (CMAKE_CXX_FLAGS "-o2")

# target_compile_options(./build/flux PRIVATE -o3)

# name of executable would be flux 
add_executable(flux src/main.cpp src/lexer.cpp src/ast.cpp src/parser.cpp)
