#include "lexer.h"
#include "token.h" // FIXME: REMOVE
#include <algorithm>

/** function tokenize goes through the main file and creates tokens out
 * of the ex
 *
 */
void Lexer::tokenize() {
    std::cout << "Starting tokenization ...\n";

    while (!end_of_file()) {
        const char current_byte = peek();
        switch (current_byte) {
        case '(':
            add_token(TOKEN_PARENTOPEN);
            break;
        case ')':
            add_token(TOKEN_PARENTCLOSE);
            break;
        case '[':
            add_token(TOKEN_BRACEOPEN);
            break;
        case ']':
            add_token(TOKEN_BRACECLOSE);
            break;
        case '{':
            add_token(TOKEN_BRACKETOPEN);
            break;
        case '}':
            add_token(TOKEN_BRACKETCLOSE);
            break;
        case ':':
            if (match(':')) {
                add_token(TOKEN_COLONCOLON);
            } else {
                add_token(TOKEN_COLON);
            }

            break;
        case '/':
            if (match('/')) { // Single line comment
                while (peek() != '\n' && !end_of_file())
                    advance();
            } else if (match('=')) {
                add_token(TOKEN_DIVIDEEQUAL);
            } else {
                add_token(TOKEN_DIVIDE);
            }
            advance();
            break;

        case '*':
            if (match('=')) {
                add_token(TOKEN_ASTERISKEQUAL);
            } else {
                add_token(TOKEN_ASTERISK);
            }
            advance();
            break;

        case '=':
            if (match('=')) {
                add_token(TOKEN_EQUALEQUAL);
            } else {
                add_token(TOKEN_EQUAL);
            }
            advance();
            break;
        case '+':
            if (match('=')) {
                add_token(TOKEN_PLUSEQUAL);
            } else if (match('+')) {
                add_token(TOKEN_PLUSPLUS);
            } else {
                add_token(TOKEN_PLUS);
            }
            advance();
            break;

        case '-':
            if (match('=')) {
                add_token(TOKEN_MINUSEQUAL);
            } else {
                add_token(TOKEN_MINUS);
            }
            advance();
            break;
        case '\n': // This is what happens when we go to a new line
            add_token(TOKEN_NEWLINE);
            this->line++;
            this->beginning_of_line = 0; // This is for column to be calculated
            break;

        case '|':
            if (match('>')) {
                add_token(TOKEN_PIPEGREATER);
            } else if (match('=')) {
                add_token(TOKEN_BITXOREQUAL);
            } else {
                add_token(TOKEN_GREATER);
            }
            break;

        case '&':
            if (match('=')) {
                add_token(TOKEN_BITANDEQUAL);
            } else {
                add_token(TOKEN_BITAND);
            }
            break;

        case '~':
            if (match('=')) {
                add_token(TOKEN_BITNOTEQUAL);
            } else {
                add_token(TOKEN_BITNOT);
            }
            break;
        case '>':
            if (match('>')) {
                if (match('=')) {
                    add_token(TOKEN_BITSHIFTRIGHTEQUAL);
                } else {
                    add_token(TOKEN_BITSHIFTRIGHT);
                }
            } else if (match('=')) {
                add_token(TOKEN_GREATEREQUAL);
            } else {
                add_token(TOKEN_GREATER);
            }
            break;
        case '<':
            if (match('<')) {
                if (match('=')) {
                    add_token(TOKEN_BITSHIFTLEFTEQUAL);
                } else {
                    add_token(TOKEN_BITSHIFTLEFT);
                }
            } else if (match('=')) {
                add_token(TOKEN_LESSEQUAL);
            } else {
                add_token(TOKEN_LESS);
            }
            break;
        case '\'':
            char_lexeme();
            break;
        case '"':
            string_lexeme();
            break;
        case '@': // Should only be used for import keyword thus far
            add_token(TOKEN_ATSIGN);
            break;
        case '.':
            add_token(TOKEN_DOT);
            break;
        case ',':
            add_token(TOKEN_COMMA);
            break;
        // Characters
        case 'a':
        case 'b':
        case 'c':
        case 'd':
        case 'e':
        case 'f':
        case 'g':
        case 'h':
        case 'i':
        case 'j':
        case 'k':
        case 'l':
        case 'm':
        case 'n':
        case 'o':
        case 'p':
        case 'q':
        case 'r':
        case 's':
        case 't':
        case 'u':
        case 'v':
        case 'w':
        case 'x':
        case 'y':
        case 'z':
        case 'A':
        case 'B':
        case 'C':
        case 'D':
        case 'E':
        case 'F':
        case 'G':
        case 'H':
        case 'I':
        case 'J':
        case 'K':
        case 'L':
        case 'M':
        case 'N':
        case 'O':
        case 'P':
        case 'Q':
        case 'R':
        case 'S':
        case 'T':
        case 'U':
        case 'V':
        case 'W':
        case 'X':
        case 'Y':
        case 'Z':
        case '_':
            literal_lexeme();
            break;
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
            number_lexeme();
            break;
        case ' ': // Spaces and so will only  iterate us forward
        case '\t':
        case '\r':
            break;
        default: // Give an error since we could not
            throw_lexer_error(UNKNOWN_CHARACTER);
            break;
        }

        // Go to next char
        advance();
    }

    // End of file
    add_token(TOKEN_EOF);

    // std::for_each(this->token_list.begin(), this->token_list.end(),
    //               [](const auto &t) { std::cout << *t << '\n'; });

    std::cout << "End of tokenization ...\n";
}

/** function match
 *
 * Will peak ahead one and see if that char matches
 * If so it advances the token once
 */
bool Lexer::match(char expected_char) {
    // If we're at the end, just stop
    if (end_of_file())
        return false;

    // TODO: This could segfault if we don't know the size of the file

    // If the next char doesn't match, we keep looking
    if (*(this->cursor_itr + 1) != expected_char)
        return false;

    // Else, we want to advance one more time since we've already looked ahead
    advance();
    return true;
}

// ====================================
//      Special cases
// ====================================
void Lexer::string_lexeme() {
    // TODO: Get substrig from  vector and save this as
    // the string
    u32 start = this->cursor;
    while (peek() != '"' && !end_of_file()) {
        if (peek() == '"') {
            this->line++;
            advance();
        }
    }
}

/** Checks if it's a quote
 *
 *
 *
 */
void Lexer::char_lexeme() {
    add_token(TOKEN_QUOTE);

    add_token(TOKEN_QUOTE);
    advance();
}

// TODO: Check if identifier is keyword or dtype
void Lexer::literal_lexeme() { advance(); }

void Lexer::number_lexeme() {
    if (peek() == '0') {
        zeros();
        return;
    }

    // NOTE: Not a float, can still be a number

    const auto start_position_itr = this->cursor_itr;
    const auto literal_start_idx = this->cursor;

    while (is_digit(*this->cursor_itr) && !end_of_file())
        advance();
}

void Lexer::zeros() {
    // We need to pass this on down the states to iterate
    const auto starting_position = this->cursor_itr;
    const auto literal_start_idx = this->cursor;

    auto next = peek_neighbor();

    if (next == '.') {
        floats(starting_position);
    } else if (next == 'x') {
        hexnumbers(starting_position);
    } else if (next == 'b') {
        binarynumbers(starting_position);
    }

    // if were e down here, they just have a lot of numbers
    while (is_digit(*this->cursor_itr) && !end_of_file())
        advance();

    const std::string literal = get_literal(starting_position);

    add_token(TOKEN_INTEGER, literal);
}

void Lexer::floats(const std::vector<char>::iterator starting_position) {
    while (is_digit(*this->cursor_itr) && !end_of_file())
        advance();

    const std::string literal = get_literal(starting_position);

    add_token(TOKEN_FLOAT, literal);
}

void Lexer::hexnumbers(const std::vector<char>::iterator starting_position) {
    while (is_hex(*this->cursor_itr) && !end_of_file())
        advance();

    const std::string literal = get_literal(starting_position);

    add_token(TOKEN_HEX, literal);
}

void Lexer::binarynumbers(const std::vector<char>::iterator starting_position) {
    while (is_bit(*this->cursor_itr) && !end_of_file())
        advance();

    const std::string literal = get_literal(starting_position);

    add_token(TOKEN_BIT, literal);
}

// ===================================================
//      ERRORS
// ===================================================

// TODO: In the future, come with corrections to user?
void Lexer::throw_lexer_error(LEXER_ERROR error_code) {
    std::cerr << "Lexer error: " << error_code << " '" << *this->cursor_itr
              << "' found in line " << this->line
              << " at column: " << this->cursor - this->beginning_of_line
              << " in file " << this->source_file << std::endl;
}
