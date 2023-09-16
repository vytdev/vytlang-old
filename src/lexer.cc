#include "../include/lexer.h"

#include <iostream>
#include <string>
using namespace std;

#include "../include/util.h"

namespace vyt {

Tokenizer::Tokenizer(const string& input) {
    _input = input;
    _len = input.length();
    // initial value of line counter
    _line = 1;
}

Token Tokenizer::tokenize() {
    Token token;
    bool foundToken = false;

    // whether we're skipping a comment
    bool singleLineComment = false;
    bool multiLineComment = false;

    while (true) {
        if (_pos >= _len) break;
        // get current char and increment _pos counter
        char ch = _input[_pos++];

        // unexpected NUL (from some editors)
        if (ch == '\0') break;

        // increment counters
        _col++;
        if (ch == '\n') {
            _col = 0;
            _line++;
        }

        // update token pos
        if (!foundToken) {
            token.line = _line;
            token.col = _col;
            token.pos = _pos;
        }

        // terminate single line comment
        if (singleLineComment) {
            if (ch == '\n') singleLineComment = false;
            continue;
        }

        // terminate multi line comments
        if (multiLineComment) {
            if (ch == '*' && _input[_pos] == '/') {
                multiLineComment = false;
                _pos++;
                _col++;
            }
            continue;
        }

        // check for comments
        if (ch == '/') {
            // single line comment
            if (_input[_pos] == '/') { singleLineComment = true; continue; }
            // multi line comment
            if (_input[_pos] == '*') { multiLineComment = true;  continue; }
        }

        // check if it is whitespace
        if (isspace(ch)) continue;

        foundToken = true;
        // TODO: the implementation
    }

    // add this token to queue
    _tokens.push_back(token);

    return token;
}

void Tokenizer::seek(const size_t& pos) {
    _idx = pos;
}

Token Tokenizer::tell(const size_t& offset) {
    return _tokens.at(_idx + offset);
}

} // namespace vyt
