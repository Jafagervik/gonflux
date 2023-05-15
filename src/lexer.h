#pragma once

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
        std::vector<char> data;
        std::vector<std::unique_ptr<Token>> token_list;

        u32 cursor;               // Where we're at in the iterator
        u32 beginning_of_line;    // Set to this->cursor each \n
        u32 beginning_of_literal; // needed for longer names to get accurate
                                  // starting point
        u16 line;                 // Incremented each \n
        char_iter cursor_itr;     // Iterator going through data

        Lexer(std::string source_file, std::vector<char> data)
            : source_file{source_file}, data{data}, cursor{0},
              beginning_of_literal{0}, beginning_of_line{0}, line{1} {
            // Alternative to cursor
            this->cursor_itr = this->data.begin();

            this->token_list = std::vector<std::unique_ptr<Token>>();
            token_list.reserve(2000);
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
            u16 column = lexeme_start - this->beginning_of_line;
            const auto location = Location{.row = this->line,
                                           .col = column,
                                           .source_file = this->source_file};

            this->token_list.push_back(
                std::make_unique<Token>(type, location, lexeme));
        }

        const std::string get_literal(const char_iter start) {
            return std::string(start, this->cursor_itr);
        }

        const std::string get_literal(const char_iter start,
                                      const char_iter end) {
            return std::string(start, end);
        }

        const char peek() { return end_of_file() ? '\0' : *this->cursor_itr; }

        const char peek_next() {
            if (this->cursor_itr + 1 != this->data.end()) {
                return *(this->cursor_itr + 1);
            }
            return '\0';
        }

        char peek_n_ahead(u32 n) {
            if (this->cursor_itr + n != this->data.end()) {
                return *(this->cursor_itr + n);
            }
            return '\0';
        }

        inline bool end_of_file() {
            return this->cursor_itr == this->data.end();
        }

        void advance() {
            ++this->cursor_itr;
            ++this->cursor;
        }

        // =========================================================
        // Lexer errors
        // =========================================================
        void throw_lexer_error(LEXER_ERROR error_code);
} Lexer;
