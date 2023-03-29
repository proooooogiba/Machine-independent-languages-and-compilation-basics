#include <iostream>
#include  <cstring>
extern "C" void delete_vowels(char*, const char* vowels="AEIOUaeiou", int vowelslen=10);
extern "C" void print_result(char* string, int s) {
    std::cout << "Vowels in English: a, e, i, o, u";
    std::cout << "\nString without vowels looks following:\n";
    for (int i = 0; i < s; i++) std::cout << string[i];
    std::cout << "\n";
    return;
};


int main () {
    char my_string[255];
    std::cout << "Input string:\n";
    std::cin.getline(my_string, 255);
    delete_vowels(my_string);
    return 0;
}
