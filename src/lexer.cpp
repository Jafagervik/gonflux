#include "lexer.h"
#include "token.h"

void Lexer::tokenize() {
    while (!end_of_file()) {
        const auto curr_sym = peek();
        switch (curr_sym) {
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
                while (peek_next() != '\n' && !end_of_file())
                    advance();
            } else if (match('*')) { // FIXME: multiline comment
                advance();
                while (!end_of_file() && peek() != '*' && peek_next() != '/')
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

            // NOTE: Floats will be handled in the parser, not here
        case '-':
            if (match('>')) {
                add_token(TOKEN_ARROW);
            } else if (match('=')) {
                add_token(TOKEN_MINUSEQUAL);
            } else {
                add_token(TOKEN_MINUS);
            }
            advance();
            break;
        case '\n': // This is what happens when we go to a new line
            new_line();
            break;

        case '|':
            if (match('>')) {
                add_token(TOKEN_PIPEGREATER);
            } else if (match('=')) {
                add_token(TOKEN_BITXOREQUAL);
            } else {
                add_token(TOKEN_BITOR);
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
        case '^':
            if (match('=')) {
                add_token(TOKEN_BITXOREQUAL);
            } else {
                add_token(TOKEN_BITXOR);
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
            if (match('\'')) {
                add_token(TOKEN_CHAR, ""); // empty char
            } else if (match('\0')) {
                throw_lexer_error(INVALID_CHAR);
            } else {
                char_lexeme();
            }
            break;
        case '"':
            if (!match('"')) { // Inverted logic since this happens most times
                string_lexeme();
            } else {
                add_token(TOKEN_STRING, ""); // Add empty string
            }
            break;
        case '@':
            if (!is_char(peek_next())) {
                add_token(TOKEN_ATSIGN);
            } else {
                if (!builtin_lexeme()) {
                    throw_lexer_error(BUILTIN_NOT_FOUND);
                    add_token(TOKEN_EOF); // NOTE: Early return
                    return;
                }
            }
            break;
        case '.':
            if (match('.')) {
                if (match('=')) {
                    add_token(TOKEN_DOTDOTEQUAL);
                } else {
                    add_token(TOKEN_DOTDOT);
                }
            } else {
                add_token(TOKEN_DOT);
            }
            break;
        case ',':
            add_token(TOKEN_COMMA);
            break;
        default:
            if (is_char(curr_sym)) {
                literal_lexeme();
            } else if (is_digit(curr_sym)) {
                number_lexeme();
            } else if (std::isspace(curr_sym)) {
                break; // NOTE: Early return
            } else {
                // Give an error since we could not
                throw_lexer_error(UNKNOWN_CHARACTER);
            }
            break;
        }
        advance(); // Go to next lexeme and start again
    }

    // End of file
    add_token(TOKEN_EOF);
}

/** function match
 *
 * Will peak ahead one and see if that char matches
 * If so it advances the token once
 */
bool Lexer::match(const char expected_char) {
    // If we're at the end, just stop
    if (end_of_file())
        return false;

    // TODO: ALSO, match does not give us the right place for start of
    // char_lexeme maybe add another int to keep track of lexeme start;

    // If the next char doesn't match, we keep looking
    if (*(this->cursor_itr + 1) != expected_char)
        return false;

    // Else, we want to advance one more time since we've already looked
    // ahead
    advance();
    return true;
}

bool Lexer::match_n(const std::string expected_string) {
    const size_t n = expected_string.size();
    auto curr_itr = this->cursor_itr + 1;

    for (int i = 0; i < n; i++) {
        if (*curr_itr == '\0') {
            return false;
        }

        if (*(curr_itr + i) != expected_string[i]) {
            return false;
        }

        curr_itr++;
    }

    // If we matched on all, advance to next
    for (size_t i = 0; i < n; i++)
        advance();
    return true;
}

void Lexer::new_line() {
    add_token(TOKEN_NEWLINE);
    this->line++;
    this->beginning_of_line = this->cursor + 1;
}

// ====================================
//      Special cases
// ====================================
void Lexer::string_lexeme() {
    advance(); // We now start at first symbol

    if (end_of_file()) {
        throw_lexer_error(UNTERMINATED_STRING);
        return;
    }

    const u16 lexeme_start = this->cursor;
    const auto start_str = this->cursor_itr;

    while (peek() != '"' && !end_of_file()) {
        if (peek() == '\n') {
            this->line++;
            this->beginning_of_line = this->cursor + 1;
        }
        advance();
    }

    if (end_of_file()) {
        throw_lexer_error(UNTERMINATED_STRING);
        return;
    }

    // Remove one since we're at closing quote
    std::string literal = get_literal(start_str, this->cursor_itr);

    add_token(TOKEN_STRING, literal, lexeme_start);
}

/**  function char_lexeme
 *
 *
 *  For the case of char, we enforce strict rules about having jsut a single
 *  character inside single quotes. This means we can early stop the lexer
 *  if such an error is found, thus this function returning a bool.
 *  Simply using `exit` would not clean up memory in an effective manner
 */
void Lexer::char_lexeme() {
    advance(); // to go the char

    const std::string c = std::string(1, peek());

    add_token(TOKEN_CHAR, c);

    advance(); // closing '
}

bool Lexer::builtin_lexeme() {
    advance(); // Start of identifier

    bool found_builtin = false;

    u32 start_idx = this->cursor;
    const auto start_itr = this->cursor_itr;

    while (is_alphanumeric(peek()))
        advance();

    const std::string literal = get_literal(start_itr);

    // Check if it is a reserved keyword
    const auto search_builtins = builtin_keywords.find(literal);

    if (search_builtins != builtin_keywords.end()) {
        TokenType token = search_builtins->second;
        add_token(token, literal, start_idx);
        found_builtin = true;
    }

    return found_builtin;
}

void Lexer::literal_lexeme() {
    u32 start_idx = this->cursor;
    const auto start_itr = this->cursor_itr;

    while (is_alphanumeric(peek()))
        advance();

    const std::string literal = get_literal(start_itr);

    // Check if it is a reserved keyword
    const auto search_keyword = keywords.find(literal);

    if (search_keyword != keywords.end()) {
        TokenType token = search_keyword->second;
        add_token(token, literal);
        return;
    }

    // Check if it is a datatype
    const auto found_datatype = ALL_DATATYPES.find(literal);

    if (found_datatype != ALL_DATATYPES.end()) {
        add_token(TOKEN_DATATYPE, literal);
        return;
    }

    // If its not a datatype nor a keyword, it's a selfdeclared identifier or
    // just a mistake
    add_token(TOKEN_IDENTIFIER, literal);
}

void Lexer::number_lexeme() {
    if (peek() == '0') {
        zeros();
    } else {
        number_internal();
    }
}

void Lexer::zeros() {
    // We need to pass this on down the states to iterate
    const auto starting_position = this->cursor_itr;
    const auto literal_start_idx = this->cursor;

    if (match('x') || match('X')) {
        hex_numbers(starting_position);
    } else if (match('b') || match('B')) {
        binary_numbers(starting_position);
    } else if (match('o') || match('O')) {
        octal_numbers(starting_position);
    }

    // If not a special case of numbers, just parse it as
    // a case of integer or floating point number
    number_internal();
}

void Lexer::hex_numbers(const char_iter starting_position) {
    while (is_hex(peek()) && !end_of_file())
        advance();

    const auto literal = get_literal(starting_position);

    PRINT(literal);

    add_token(TOKEN_HEX, literal);
}

void Lexer::binary_numbers(const char_iter starting_position) {
    while (is_bit(peek()) && !end_of_file())
        advance();

    const auto literal = get_literal(starting_position);

    PRINT(literal);

    add_token(TOKEN_BIT, literal);
}

void Lexer::octal_numbers(const char_iter starting_position) {
    while (is_octal(peek()) && !end_of_file())
        advance();

    const auto literal = get_literal(starting_position);

    PRINT(literal);

    add_token(TOKEN_OCTAL, literal);
}

/** function number internal
 *
 *  This function handles each case where we can only
 *  have a normal int or float number.
 *  Since we can have different number types,
 *
 */
void Lexer::number_internal() {
    const auto start_position_itr = this->cursor_itr;
    const auto start_idx = this->cursor;
    bool is_float = false;

    while (is_digit(peek()) && !end_of_file())
        advance();

    if (peek() == '.' && is_digit(peek_next())) {
        is_float = true;
        advance();

        while (is_digit(peek()) && !end_of_file())
            advance();
    }

    const auto literal = get_literal(start_position_itr);

    PRINT(literal);

    const auto token = is_float ? TOKEN_FLOAT : TOKEN_INTEGER;

    add_token(token, literal);
}

// ===================================================
//      ERRORS
// ===================================================

void Lexer::throw_lexer_error(LEXER_ERROR error_code) {
    std::cerr << "Lexer error: " << nameLE[error_code - 1] << " '"
              << *this->cursor_itr << "' found in line " << this->line
              << " at column: " << this->cursor - this->beginning_of_line
              << " in file " << this->source_file << std::endl;
}
