# C-- Compiler

A compiler for the fictional programming language C--, a subset of C.  This compiler consists of a
lexical analyzer (scanner), syntax analyzer (syntax error detection and builds an abstract syntax tree), semantic analyzer (name and type analysis), and code generator (MIPS assembly generation.)

### The C-- Language

The following defines the lexical level of the C-- language.

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
  * Characters can be otherwise normal characters: `a`, `b`, `c`, `d`, ... (other than newline, double quote, or backslash.)

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

We do not assume that there are any limits on the lengths of identifiers, string literals, integer literals, comments, etc.

### Getting Started

Testing the compiler is very easy.

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
5. Run the CompilerTester on the "Hello world!" C-- program, hello.txt, residing in the test folder.
```
$ java -cp src:deps CompilerTester test/hello.txt test/hello.s
```
6. Check out the generated MIPS assembly with your favorite text editor.
```
nano test/hello.s
```

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
4. Simulate the generated MIPS32 assembly code in hello.s using QtSpim.
```
$ QtSpim test/hello.s
```
