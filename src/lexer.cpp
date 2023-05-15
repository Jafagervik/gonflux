#include "lexer.h"
#include "constants.h"
#include "token.h"

/** function tokenize goes through the main file and creates tokens out
 * of the ex
 *
 */
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
                while (peek() != '\n' && !end_of_file())
                    advance();
            } else if (match('*')) { // multiline comment
                advance();
                while (!end_of_file() && peek() != '*' &&
                       peek_neighbor() != '/')
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
            if (char_lexeme()) {
                break;
            } else {
                throw_lexer_error(UNTERMINATED_CHAR);
                add_token(TOKEN_EOF); // NOTE: Early return
                return;
            }
        case '"':
            if (!match('"')) { // Inverted logic since this happens most times
                string_lexeme();
                break;
            }
            add_token(TOKEN_STRING, ""); // Add empty string
            break;
        case '@': // NOTE: KEYWORDS

            if (match_n("import")) {
                add_token(TOKEN_IMPORT, "import");
            } else {
                add_token(TOKEN_ATSIGN);
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
                break; // Just break  directly here
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

    std::for_each(this->token_list.begin(), this->token_list.end(),
                  [](const auto &t) { std::cout << *t << '\n'; });
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

// ====================================
//      Special cases
// ====================================
void Lexer::string_lexeme() {
    // NOTE: For now, empty strings are handled in the switch

    advance(); // We now start at first symbol

    if (end_of_file()) {
        throw_lexer_error(UNTERMINATED_STRING);
        return;
    }

    const u32 start_idx = this->cursor;
    const std::vector<char>::iterator start_str = this->cursor_itr;

    while (peek() != '"' && !end_of_file()) {
        if (peek() == '\n') {
            this->line++;
            this->beginning_of_line = 0;
        }
        advance();
    }

    if (end_of_file()) {
        throw_lexer_error(UNTERMINATED_STRING);
    }

    // Remove one since we're at closing quote
    std::string literal = get_literal(start_str, this->cursor_itr);

    add_token(TOKEN_STRING, literal, start_idx);
}

/**  function char_lexeme
 *
 *
 *  For the case of char, we enforce strict rules about having jsut a single
 *  character inside single quotes. This means we can early stop the lexer
 *  if such an error is found, thus this function returning a bool.
 *  Simply using `exit` would not clean up memory in an effective manner
 */
bool Lexer::char_lexeme() {
    if (peek_n_ahead(2) == '\'' || peek_neighbor() == '\0') {
        throw_lexer_error(UNTERMINATED_CHAR);
        return false;
    }

    advance(); // to go the char

    const std::string c = std::string(1, peek());

    PRINT(c);

    add_token(TOKEN_CHAR, c);

    advance(); // closing '

    return true;
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
        return;
    }

    // NOTE: Not a float, can still be a number

    const auto start_position_itr = this->cursor_itr;
    const auto start_idx = this->cursor;

    while (is_digit(peek()) && !end_of_file())
        advance();

    const std::string literal = get_literal(start_position_itr);

    // TODO: handle float in this case
    if (literal.find('.') != std::string::npos) {
        return;
    }
}

void Lexer::zeros() {
    // We need to pass this on down the states to iterate
    const auto starting_position = this->cursor_itr;
    const auto literal_start_idx = this->cursor;

    auto next = peek_neighbor();

    if (next == '.') {
        advance();
        floats(starting_position);
    } else if (next == 'x' or next == 'X') {
        advance();
        hexnumbers(starting_position);
    } else if (next == 'b' || next == 'B') {
        advance();
        binarynumbers(starting_position);
    }

    // if were e down here, they just have a lot of numbers
    while (is_digit(*this->cursor_itr) && !end_of_file())
        advance();

    const std::string literal = get_literal(starting_position);

    add_token(TOKEN_INTEGER, literal);
}

void Lexer::floats(const std::vector<char>::iterator starting_position) {
    while (is_digit(peek()) && !end_of_file())
        advance();

    const std::string literal = get_literal(starting_position);

    add_token(TOKEN_FLOAT, literal);
}

void Lexer::hexnumbers(const std::vector<char>::iterator starting_position) {
    while (is_hex(peek()) && !end_of_file())
        advance();

    const std::string literal = get_literal(starting_position);

    add_token(TOKEN_HEX, literal);
}

void Lexer::binarynumbers(const std::vector<char>::iterator starting_position) {
    while (is_bit(peek()) && !end_of_file())
        advance();

    const std::string literal = get_literal(starting_position);

    add_token(TOKEN_BIT, literal);
}

// ===================================================
//      ERRORS
// ===================================================

void Lexer::throw_lexer_error(LEXER_ERROR error_code) {
    std::cerr << "Lexer error: " << nameLE[error_code] << " '"
              << *this->cursor_itr << "' found in line " << this->line
              << " at column: " << this->cursor - this->beginning_of_line
              << " in file " << this->source_file << std::endl;
}
