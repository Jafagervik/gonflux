#pragma once

// #include "basic_istream"
#include "constants.h"
#include "pch.h"
#include "token.h"
#include <algorithm>
#include <cstddef>
#include <functional>
#include <iostream>
#include <memory>
#include <ostream>
#include <vector>

using char_iter = std::vector<char>::iterator;

typedef struct Lexer {
        // TODO: Add more files when dealing with
        std::string source_file;
        // std::vector<char> data;
        std::vector<std::unique_ptr<Token>> token_list;

        std::ifstream *file;
        std::string current_lexeme; // stores the lexeme we're building with
        char curr_sym;              // Current char we're looking at

        u32 cursor;               // Where we're at in the iterator
        u32 beginning_of_line;    // Set to this->cursor each \n
        u32 beginning_of_literal; // needed for longer names to get accurate
                                  // starting point
        u16 line;                 // Incremented each \n
        // char_iter cursor_itr;     // Iterator going through data

        Lexer(std::string source_file, std::ifstream *file)
            : source_file{source_file}, file{file}, cursor{0},
              beginning_of_literal{0}, beginning_of_line{0}, line{1} {
            // Alternative to cursor
            // this->cursor_itr = this->data.begin();

            this->token_list = std::vector<std::unique_ptr<Token>>();
            token_list.reserve(5000);
        }

        void tokenize();

        // Specific tokenizers
        bool match(const char expected_char);            // LOOKAHEAD
        bool match_n(const std::string expected_string); // LOOKAHEAD n times
        void new_line();

        // ===============================
        //  Methods for handling lexemes
        // ===============================
        void string_lexeme();  // Starts with "
        void literal_lexeme(); // Everything else except builtins
        bool builtin_lexeme(); // keywords starting with @
        void char_lexeme();    // // starts with ' and is of max one char
        void number_lexeme();  // all kinds of numbers

        // ============================================================
        // More specific number handling
        //=============================================================
        void zeros();
        void hex_numbers();
        void binary_numbers();
        void octal_numbers();
        void math_numbers();

        void special_number_internal(TokenType token_type,
                                     std::function<bool(char)> filter);
        void number_internal();

        // ===============================
        //   Helper methods
        // ===============================
        void add_token(TokenType type) {
            u16 column = this->cursor - this->beginning_of_line;
            const auto location = Location{.row = this->line,
                                           .col = column,
                                           .source_file = this->source_file};

            this->token_list.push_back(std::make_unique<Token>(type, location));
        }

        void add_token(TokenType type, const std::string lexeme) {
            u16 column = this->cursor - this->beginning_of_line;
            const auto location = Location{.row = this->line,
                                           .col = column,
                                           .source_file = this->source_file};

            this->token_list.push_back(
                std::make_unique<Token>(type, location, lexeme));
        }

        void add_token(TokenType type, const std::string lexeme,
                       u16 lexeme_start) {
            const u16 column = lexeme_start - this->beginning_of_line;
            const auto location = Location{.row = this->line,
                                           .col = column,
                                           .source_file = this->source_file};

            this->token_list.push_back(
                std::make_unique<Token>(type, location, lexeme));
        }

        // NOTE: Multiline tokens where we want position from earlier on
        void add_token(TokenType type, const std::string lexeme,
                       u16 lexeme_start_row, u16 lexeme_start_col,
                       u32 lexeme_beginning_of_line) {
            u16 column = lexeme_start_col - lexeme_beginning_of_line;
            const auto location = Location{.row = lexeme_start_row,
                                           .col = column,
                                           .source_file = this->source_file};

            this->token_list.push_back(
                std::make_unique<Token>(type, location, lexeme));
        }

        const char peek() { return file->peek(); }

        const char peek_next(u16 k = 1) {

            auto next = file->peek();
            return (next != EOF && next.good()) ? next : '\0';
        }

        char peek_n_ahead(u32 n) {
            size_t next;
            for (size_t i = 0; i < n; ++i) {
                next = this->file->peek();
                if (!(next != EOF && next.good()))
                    return '\0';
            }

            return next.peek();
        }

        inline bool end_of_file() {
            return this->file->peek() != EOF && file->good();
        }

        // TODO: append to current string
        void advance() {
            this->current_lexeme += this->file->get();
            ++this->cursor;
        }

        // =========================================================
        // Lexer errors
        // =========================================================
        void throw_lexer_error(LEXER_ERROR error_code);
} Lexer;
