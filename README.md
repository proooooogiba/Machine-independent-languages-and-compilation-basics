# Machine-independent-languages-and-compilation-basics
This repository is created for storage labs and homeworks for course 'Machine independent languages and compilation basics'

### **[Лабораторная работ №1. Изучение среды и отладчика ассембелера](https://github.com/proooooogiba/Machine-independent-languages-and-compilation-basics/tree/main/lab1)**
Изученить процессы создания, запуска и отладки программ на ассемблере Nasm под управлением операционной системы Linux, а также особенностей описания и внутреннего представления данных.

### **[Лабораторная работ №2. Программирование целочисленных вычислений](https://github.com/proooooogiba/Machine-independent-languages-and-compilation-basics/tree/main/lab2)**
Вычислить целочисленное выражение:
![2](https://user-images.githubusercontent.com/55802440/228671327-81bb6ce1-27e5-4ef3-b4af-4b789fc61573.png)

### **[Лабораторная работ №3. Программирование ветвлений и циклов](https://github.com/proooooogiba/Machine-independent-languages-and-compilation-basics/tree/main/lab3)**
Вычислить целочисленное выражение:
![3](https://user-images.githubusercontent.com/55802440/228671610-ad9195be-2960-4bf1-8add-ab1e143de7c6.png)

### **[Лабораторная работ №4. Программирование обработки массивов и матриц](https://github.com/proooooogiba/Machine-independent-languages-and-compilation-basics/tree/main/lab4)**
Дана матрица 5х4. Вычеркнуть строки с нулевой сум¬мой элементов. Организовать ввод матрицы и вывод результатов.

### **[Лабораторная работ №5. Программирование с использованием разноязыковых модулей](https://github.com/proooooogiba/Machine-independent-languages-and-compilation-basics/tree/main/lab5)**
Дан текст не более 255 символов. Слова отделяются друг от друга пробелами. Удалить из слов гласные буквы.

### **[Домашнее задание №1. Обработка символьной информации](https://github.com/proooooogiba/Machine-independent-languages-and-compilation-basics/tree/main/hw1)**
Дано 8 слов по 6 символов. В начале каждого слова записан номер из двух символов. Расставить слова по возрастанию номеров.

### **[Домашнее задание №2. Лексические и синтаксические анализаторы](https://github.com/proooooogiba/Machine-independent-languages-and-compilation-basics/tree/main/hw2)**
Разработать грамматику и распознаватель описания языка программирования C++, включающего оператор цикла-пока и оператор присваивания. Считать, что условие – значение переменной логического типа, тело цикла содержит не более одного оператора, а оператор присваивания в правой части содержит только идентификаторы или целые константы. Например:
**while (d) while (ii) gyu=5;**
*********************************
### **Описание грамматики в форме Бэкуса–Наура:**
1. <команда> ::= <цикл> | <присваивание>
2. <присваивание> ::= <идентификатор> <знак присваивания> <присваиваемое><;>
3. <присваиваемое>::= <число> | <строка> | <идентификатор>
4. <цикл> ::= <начало цикла> <открывающие скобки> <идентификатор> <закрывающие скобки> <команда>|<;>
5. <начало цикла> ::= while,
7. <знак присваивания> ::= =
6. <число> ::= <знак><цифра>…<цифра>
7. <цифра> ::= 0 |1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
8. <символ>::= <буква>|<цифра>
9. <строка>::= <двойная кавычка><символ>…<символ><двойная кавычка>
10. <идентификатор> ::= <буква><символ>...<символ>
11. <буква> ::= a | b | c | d | e | f | g | h | i | j | k | l | m | n | o | p | q | r | s | t | u | v | w | x | y | z | A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q |
 R | S | T | U | V | W | X | Y | Z
12. <знак> ::= + | -

#### **Синтаксические диаграммы:**

Правило построения нетерминала <команда> включает рекурсивное вложение: <цикл> в конечном счете определяется через <цикл>. Следовательно, это грамматика второго типа по [**Хомскому**](https://neerc.ifmo.ru/wiki/index.php?title=%D0%98%D0%B5%D1%80%D0%B0%D1%80%D1%85%D0%B8%D1%8F_%D0%A5%D0%BE%D0%BC%D1%81%D0%BA%D0%BE%D0%B3%D0%BE_%D1%84%D0%BE%D1%80%D0%BC%D0%B0%D0%BB%D1%8C%D0%BD%D1%8B%D1%85_%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B0%D1%82%D0%B8%D0%BA)

![Синтаксическая диаграмма](https://user-images.githubusercontent.com/55802440/228677190-ed3a2867-b3e4-4095-bd22-a32a6d71d78b.png)
