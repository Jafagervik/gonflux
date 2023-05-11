#pragma once

#include "constants.h"
#include "pch.h"
#include "token.h"
#include <algorithm>
#include <array>
#include <cstddef>
#include <iostream>
#include <memory>
#include <ostream>
#include <string_view>
#include <unordered_map>
#include <vector>

const static std::unordered_map<std::string, TokenType> keywords = {
    {"if", TOKEN_IF},         {"then", TOKEN_THEN},
    {"while", TOKEN_WHILE},   {"elseif", TOKEN_ELSEIF},
    {"else", TOKEN_ELSE},     {"struct", TOKEN_STRUCT},
    {"enum", TOKEN_ENUM},     {"return", TOKEN_RETURN},
    {"end", TOKEN_END},       {"import", TOKEN_IMPORT},
    {"export", TOKEN_EXPORT}, {"null", TOKEN_NULL},
    {"in", TOKEN_IN},         {"throw", TOKEN_THROW},
    {"type", TOKEN_TYPE},     {"try", TOKEN_TRY},
    {"typeof", TOKEN_TYPEOF}, {"continue", TOKEN_CONTINUE},
    {"break", TOKEN_BREAK},   {"catch", TOKEN_CATCH},
    {"mut", TOKEN_MUT},       {"compiletime", TOKEN_COMPILETIME},
    {"atomic", TOKEN_ATOMIC}, {"parallel", TOKEN_PARALLEL}};

const static std::array<std::string, 15> supported_number_datatypes = {
    "u8",  "u16",  "u32", "u64", "u128", "i8",  "i16", "i32",
    "i64", "i128", "f8",  "f16", "f32",  "f64", "f128"};

/** Struct contains impl for what what we're trying to achieve
 *
 */
typedef struct Lexer {
        // TODO: Add more files when dealing with
        //
        std::string source_file;
        std::vector<char> data;
        std::vector<std::unique_ptr<Token>> token_list;

        u32 cursor;            // Where we're at in the iterator
        u32 beginning_of_line; // Set to 0 each \n
        u32 line;              // Incremented each \n
        std::vector<char>::iterator cursor_itr;

        // Construtor
        Lexer(std::string source_file, std::vector<char> data)
            : source_file{source_file}, data{data}, cursor{0},
              beginning_of_line{0}, line{0} {
            // Alternative to cursor
            this->cursor_itr = this->data.begin();

            // TODO: Look into buffering of tokens.
            // eg. every amount of tokens, buffer and send to parser?
            this->token_list = std::vector<std::unique_ptr<Token>>();
            token_list.reserve(2000);
        }

        // Main function that tokenizes
        void tokenize();

        // Specific tokenizers
        bool match(const char expected_char);            // LOOKAHEAD
        bool match_n(const std::string expected_string); // LOOKAHEAD n times

        // ===============================
        //  Methods for handling lexemes
        // ===============================
        void string_lexeme();
        void literal_lexeme();
        bool char_lexeme(); // Add bool to early stop if need be
        void number_lexeme();

        // ====================
        // More specific number handling
        //===================
        void zeros();

        void floats(const std::vector<char>::iterator starting_position);
        void hexnumbers(const std::vector<char>::iterator starting_position);
        void binarynumbers(const std::vector<char>::iterator starting_position);

        void add_token(TokenType type) {
            auto location =
                Location{.row = this->line,
                         .col = this->cursor - this->beginning_of_line,
                         .source_file = this->source_file};

            this->token_list.emplace_back(
                std::make_unique<Token>(Token(type, location, nullptr)));
        }

        void add_token(TokenType type, std::string lexeme) {
            auto location =
                Location{.row = this->line,
                         .col = this->cursor - this->beginning_of_line,
                         .source_file = this->source_file};

            this->token_list.emplace_back(
                std::make_unique<Token>(Token(type, location, &lexeme)));
        }

        char peek() {
            if (end_of_file()) {
                return '\0';
            }
            return *this->cursor_itr;
        }

        char peek_neighbor() {
            if (this->cursor_itr + 1 != this->data.end()) {
                return *(this->cursor_itr + 1);
            }
            return '\0';
        }

        // TODO: Possibly remove
        char peek_n_ahead(u32 n) {
            if (this->cursor_itr + n != this->data.end()) {
                return *(this->cursor_itr + n);
            }
            return '\0';
        }

        bool end_of_file() { return this->cursor_itr == this->data.end(); }

        void advance() {
            ++this->cursor_itr;
            ++this->cursor;
        }

        bool is_digit(char c) { return c >= '0' && c <= '9'; }

        bool is_bit(char c) { return c == '0' || c == '1'; }

        bool is_hex(char c) {
            return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') ||
                   (c >= 'A' && c <= 'F');
        }

        /** from the vector of chars or pointer, get
         *  us the substring telling us what the literal is
         * TODO: see if this is inded correct
         */
        const std::string get_literal(const std::vector<char>::iterator start) {
            std::cout << "get literal Lexeme " << *start << *this->cursor_itr
                      << std::endl;
            return std::string(start, this->cursor_itr);
        }

        // TODO: Optimize with bits or something
        bool is_char(char c) {
            return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') ||
                   (c == '_');
        }

        bool is_alphanumeric(char c) { return is_digit(c) || is_char(c); }

        // Lexer errors
        void throw_lexer_error(LEXER_ERROR error_code);

} Lexer;
