# C-- Compiler

A compiler for the fictional programming language C--, a subset of C.  Written in Java and using the LALR generator JavaCUP, this compiler consists of a
lexical analyzer (scanner), syntax analyzer (syntax error detection and builds an abstract syntax tree), semantic analyzer (name and type analysis), and code generator (MIPS assembly generation.)


## Getting Started

Trying out the compiler is very easy.

1. Clone or download this repository.
2. Navigate to the repository directory.
```
$ cd /path/to/repository/Cmm-Compiler
```
3. Clean the repository of temporary files, object files, and executables.
```
$ make clean
```
4. Compile the Cmm-Compiler.
```
$ make
```
5. If you want to see a simple compilation, run the CompilerTester on the "Hello, World!" C--
program, hello.cmm, residing in the demo folder.
```
$ java -cp src:deps CompilerTester demo/hello.cmm demo/hello.s
```
6. Then check out the generated MIPS assembly with your favorite text editor.
```
$ vim demo/hello.s
```
7. If you want to see a more complex compilation, check out the demo C-- program, demo.cmm, residing
   in the demo folder, and compare it to the provided MIPS assembly file: demo.s.  You can also
   compile the demo C-- program analogous to the hello.cmm program:
```
$ java -cp src:deps CompilerTester demo/demo.cmm demo/demo.s
```

If you want to see how the compiler handles errors, run the CompilerTester on the error-ridden
   C-- program, error.txt, residing in the test folder.
```
$ java -cp src:deps CompilerTester demo/error.cmm demo/error.s
```
This will print the errors encountered and generate an empty MIPS assembly file, error.s.

If you want to simulate the MIPS assembly, I suggest that you download the MIPS32 simulator,
[QtSpim](http://spimsimulator.sourceforge.net/).  You can download the appropriate QtSpim for your
system [here](https://sourceforge.net/projects/spimsimulator/files/).  E.g., if you were downloading
QtSpim Version 9.1.17 for 64-bit Linux, you could do the following:

1. Download the .deb file.
```
$ wget -O /path/to/download/folder/qtspim_9.1.17_linux64.deb https://sourceforge.net/projects/spimsimulator/files/qtspim_9.1.17_linux64.deb/download 
```
2. Install QtSpim using the Debian package manager.
```
$ sudo dpkg -i /path/to/download/folder/qtspim_9.1.17_linux64.deb
```
3. Navigate to the Cmm-Compiler repository directory.
4. Simulate the generated MIPS32 assembly code in demo.s using QtSpim.
```
$ qtspim demo/demo.s
```

## The C-- Language

### Syntax

The following defines the lexical level and the syntax of the C-- language.

#### Tokens

* Reserved words
  * Types:
    * `bool`
    * `int`
    * `void`
    * `struct`
    * `function` (not a reserved word, though.)
  * `true`
  * `false`
  * `cin`
  * `cout`
  * `if`
  * `else`
  * `while`
  * `return`
* Operators
  * `{`
  * `}`
  * `(`
  * `)`
  * `;`
  * `,`
  * `.`
  * `<<`
  * `>>`
  * `++`
  * `--`
  * Logical:
    * `!`
    * `&&`
    * `||`
  * Arithmetic
    * `+`
    * `-`
    * `*`
    * `/`
    * `-`
  * Equality:
    * `==`
    * `!=`
  * Relational:
    * `<`
    * `>`
    * `<=`
    * `>=`
  * Assignment:
    * `=`
* Identifiers: A sequence of one or more letters and/or digits, and/or underscores.  A valid
  identifier must begin with a letter or udnerscore but cannot be a reserved word.
* Integer Literals: A sequence of one or more digits.
* String Literals: A sequence of zero or more characters surrounded by double quotes.
  * Characters can be escaped: `\n`, `\t`, `\'`, `\"`, `\?`, `\\`
  * Characters can be otherwise normal characters: `a`, `b`, `c`, `d`, ... (other than newline,
  double quote, or backslash.)

#### Comments

Text starting with a double slasl (`//`) or a sharp sign (`#`) is considered to be a comment up
until the end of the line.
* `// this is a comment`
* `# this is a comment`
* `"#" this is not a comment`

#### Whitespace

Spaces, tabs, and new line characters are whitespace.  Whitespace separates tokens and changes the
character counter but is otherwise be ignored (except inside a string literal.)

#### Illegal Characters

Any character that is not whitespace and is not part of a token or comment is illegal.

#### Length Limits

We do not assume that there are any limits on the lengths of identifiers, string literals, integer
literals, comments, etc.

#### Operator Precedences and Associativities

* Assignment (=) is right associative.
* The dot (.)operator is left associative.
* The relational and equality operators (<, >, <=, >=, ==, and !=) are non-associative (i.e.,
expressions like a < b < c are not allowed and should cause a syntax error).
* All other binary operators are left associative.
* The unary minus (-) and not (!) operators have the highest precedence, then multiplication and
division, then addition and subtraction, then the relational and equality operators, then the
logical and operator (&&), then the logical or operator (||), and finally the assignment operator
(=).

### Semantics

#### Type Specification

The type rules of the C-- language are as follows:
* **logical operators and conditions:** Only boolean expressions can be used as operands of logical
operators or in the condition of an if or while statement. The result of applying a logical operator
to bool operands is bool.
* **arithmetic and relational operators:** Only integer expressions can be used as operands of these
operators. The result of applying an arithmetic operator to int operand(s) is int. The result of
applying a relational operator to int operands is bool.
* **equality operators:** Only integer or boolean expressions can be used as operands of these
operators. Furthermore, the types of both operands must be the same. The result of applying an
equality operator is bool.
* **assignment operator:** Only integer or boolean expressions can be used as operands of an
assignment operator. Furthermore, the types of the left-hand side and right-hand side must be the
same. The type of the result of applying the assignment operator is the type of the right-hand side.
* **cout and cin:** Only an int or bool expression or a string literal can be printed by cout. Only
an int or bool identifer can be read by cin. Note that the identifier can be a field of a struct type
(accessed using . ) as long as the field is an int or a bool.
* **function calls:** A function call can be made only using an identifier with function type (i.e.,
an identifier that is the name of a function). The number of actuals must match the number of
formals.
The type of each actual must match the type of the corresponding formal.
* **function** returns:
  * A void function may not return a value.
  * A non-void function may not have a return statement without a value.
  * A function whose return type is int may only return an int; a function whose return type is bool
    may only return a bool.

#### Other Semantics

* The and and or operators (`&&` and `||`) are short circuited.
* In C-- (as in C++ and Java), two string literals are considered equal if they contain the same
sequence of characters. So for example, the first two of the following expressions should evaluate
to false and the last two should evaluate to true:
  ```
  "a" == "abc"
  ```
  ```
  "a" == "A"
  ```
  ```
  "a" == "a"
  ```
  ```
  "abc" == "abc"
  ```
* Boolean values are output as 1 for true and 0 for false.
* Boolean values are input using 1 for true and 0 for false.
