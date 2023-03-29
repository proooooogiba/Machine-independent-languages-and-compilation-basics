#include <iostream>
#include <cstring>
enum Lex
{
    While,
    Identificator,
    Assign,
    Semicolon,
    Openbrackets,
    Closebrackets,
    Number,
    Stringliteral,
    Error
};
Lex lex;
char str[255];
size_t k = 0;

bool isSign(char ch) {
    return ch == '+' || ch == '-';
}

bool checkInt(char* sym) {
    size_t i = 0;
    int k = 1;
    if (isSign(sym[0]))
       i++;

    while (i < strlen(sym) && isdigit(sym[i]))
        i++;

    return i == strlen(sym);
}

bool checkIdentificator(char* symbols, int j) {
    if (!isalpha(symbols[0]))
        return false;

    for (int k = 1; k < j; k++) {
        if (!isalpha(symbols[k]) && !isdigit(symbols[k]))
            return false;
    }
    return true;
}

bool checkStringLiteral(char* symbols, int j) {
    if (symbols[0] == '\"' || symbols[j-1] == '\"' || ((symbols[0] == '\'' || symbols[j-1] == '\'') && j == 3))
        return true;
    return false;
}

Lex getLex(char* str, size_t& i) {
    while (isspace(str[i]))
        i++;

    switch (str[i])
    {
    case ';':
        i++;
        return Semicolon;
    case '=':
        i++;
        return Assign;
    case '(':
        i++;
        return Openbrackets;
    case ')':
        i++;
        return Closebrackets;
    default:
        break;
    }

    char symbols[50];
    int j = 0;
    while (i < strlen(str) && (isdigit(str[i]) || isalpha(str[i]) || isSign(str[i]) || str[i] == '\'' || str[i] == '\"')) {
        symbols[j] = str[i];
        j++;
        i++;
    }
    symbols[j] = '\0';

    if (strcmp(symbols, "while") == 0)
        return While;

    if (checkInt(symbols))
        return Number;

    if (checkIdentificator(symbols, j))
        return Identificator;
    
    if (checkStringLiteral(symbols, j))
        return Stringliteral;
    
    return Error;
}

void internalCycle() {
    if (lex == Openbrackets)
        lex = getLex(str, k);
    else
        throw "expected '('\n";

    if (lex == Identificator)
        lex = getLex(str, k);
    else
        throw "expected Identificator\n";

    if (lex == Closebrackets)
        lex = getLex(str, k);
    else
        throw "expected ')'\n";
}

void assignComand() {
    if (lex == Identificator)
        lex = getLex(str, k);
    else
        throw "identificator\n";

    if (lex == Assign)
        lex = getLex(str, k);
    else
        throw "expected '='\n";

    if (lex == Number || lex == Stringliteral || lex == Identificator)
        lex = getLex(str, k);
    else
        throw "expected number or string literal\n";

    if (lex == Semicolon)
        lex = getLex(str, k);
    else
        throw "expected ';'\n";
}

void mainCycle() {
    if (lex == While)
        lex = getLex(str, k);
    else
        throw "expected 'while'\n";

    if (lex == Openbrackets)
        lex = getLex(str, k);
    else
        throw "expected '('\n";

    if (lex == Identificator)
        lex = getLex(str, k);
    else
        throw "expected Identificator\n";

    if (lex == Closebrackets)
        lex = getLex(str, k);
    else
        throw "expected ')' ";

    while (lex == While) {
        lex = getLex(str, k);
        internalCycle();
    }

    if (lex == Semicolon) {
        lex = getLex(str, k);
        return;
    } else if (lex == Identificator)
        assignComand();
    else
        throw "expected while or identificator\n";

}

void syntax_analisator()
{
    lex = getLex(str, k);
    while (k < strlen(str)) {
        if (lex == While)
            mainCycle();
        else if (lex == Identificator)
            assignComand();
        else
            throw "expected while or identificator";
    }
}

int main() {
    std::cout << "Input string: \n";
    try {
        std::cin.getline(str, 255);
        syntax_analisator();
        std::cout << "There isn't any syntax error\n";
    }
    catch (const char* bad_mes) {
        std::cout << bad_mes;
    }
}
