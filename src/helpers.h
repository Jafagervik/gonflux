#pragma once

inline bool is_digit(char c) { return c >= '0' && c <= '9'; }

inline bool is_octal(char c) { return c >= '0' && c <= '7'; }

inline bool is_bit(char c) { return c == '0' || c == '1'; }

inline bool is_hex(char c) {
    return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') ||
           (c >= 'A' && c <= 'F');
}

inline bool is_char(char c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c == '_');
}

inline bool is_alphanumeric(char c) { return is_digit(c) || is_char(c); }
