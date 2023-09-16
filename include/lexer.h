#ifndef LEXER_H
#define LEXER_H

#include <string>
#include <vector>
using namespace std;

namespace vyt {

struct Token {
    string value;
    /* token information */
    size_t line;
    size_t col;
    size_t pos;
};

/* tokenization class */
class Tokenizer {
    private:
    /* counters */
    size_t _line;
    size_t _col;
    size_t _pos;
    /* the current token seek idx */
    size_t _idx;
    /* input string for tokenization */
    string _input;
    size_t _len;
    /* current processed tokens */
    vector<Token> _tokens;

    public:
    /* create a new Tokenizer for given text */
    Tokenizer(const string& input);
    /* process next token and return that */
    Token tokenize();
    /* seek to specified token position */
    void seek(const size_t& pos);
    /* return the value of the token at current position, or offset from current
    position to given index */
    Token tell(const size_t& offset = 0);
};

} // namespace vyt

#endif // LEXER_H
