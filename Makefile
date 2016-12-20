###
# This Makefile can be used to make a parser for the C-- language
# (parser.class) and to make a program (P4.class) that tests the parser and
# the unparse methods in ast.java.
#
# make clean removes all generated files.
#
###

JCC = javac
JVM = java
SRCDIR = src
DEPDIR = deps
CP = $(SRCDIR):$(DEPDIR)
CPFLAGS = -cp $(CP)
JFLAGS = -g $(CPFLAGS)

SRCEXT = java
CLSEXT = class

SRC = $(wildcard $(SRCDIR)/*.$(SRCEXT))
CLS = $(SRC:.$(SRCEXT)=.$(CLSEXT))

VPATH = $(SRCDIR):$(DEPDIR)

RM = rm
RMFLAGS = -f
RMTARGETS = $(addprefix $(SRCDIR)/, *~ *.class parser.java CMM.jlex.java sym.java) 

.SUFFIXES: .java .class

.PHONY: clean

# NOTE: Needed to hackily move/remove some files that end up in the root project directory
#       post-compilation.  This should probably be fixed.

CompilerTester.class: CompilerTester.java parser.class Yylex.class ASTnode.class
	$(JCC) $(JFLAGS) $(CPFLAGS) $<
	@rm -f ./parser.java

parser.class: $(SRCDIR)/parser.java ASTnode.class Yylex.class ErrMsg.class
	$(JCC) $(CPFLAGS) $<

$(SRCDIR)/parser.java: CMM.cup
	$(JVM) $(CPFLAGS) java_cup.Main < $<
	@mv ./parser.java $(SRCDIR)/parser.java

Yylex.class: $(SRCDIR)/CMM.jlex.java sym.class ErrMsg.class
	$(JCC) $(CPFLAGS) $<

ASTnode.class: ast.java Type.java
	$(JCC) $(JFLAGS) $(CPFLAGS) $<

$(SRCDIR)/CMM.jlex.java: CMM.jlex sym.class
	$(JVM) $(CPFLAGS) JLex.Main $<

sym.class: $(SRCDIR)/sym.java
	$(JCC) $(JFLAGS) $(CPFLAGS) $<

$(SRCDIR)/sym.java: CMM.cup
	$(JVM) $(CPFLAGS) java_cup.Main < $<
	@mv ./sym.java $(SRCDIR)/sym.java

ErrMsg.class: ErrMsg.java
	$(JCC) $(CPFLAGS) $<

Sym.class: Sym.java Type.java ast.java
	$(JCC) $(JFLAGS) $(CPFLAGS) $<

SymTable.class: SymTable.java Sym.java DuplicateSymException.java EmptySymTableException.java
	$(JCC) $(JFLAGS) $(CPFLAGS) $<

Type.class: Type.java
	$(JCC) $(JFLAGS) $(CPFLAGS) $<

DuplicateSymException.class: DuplicateSymException.java
	$(JCC) $(JFLAGS) $(CPFLAGS) $<

EmptySymTableException.class: EmptySymTableException.java
	$(JCC) $(JFLAGS) $(CPFLAGS) $<

Codegen.class:	Codegen.java
	$(JCC) $(CPFLAGS) $<


# %.$(CLSEXT) : %.$(SRCEXT)
# 	$(JCC) $(JFLAGS) $<

# CompilerTester.class: parser.class Yylex.class ASTnode.class

# parser.class: ASTnode.class Yylex.class ErrMsg.class

# parser.java: CMM.cup
# 	$(JVM) $(CPFLAGS) java_cup.Main < $<

# Yylex.class: CMM.jlex.java sym.class ErrMsg.class
# 	$(JCC) $(CPFLAGS) $<

# ASTnode.class: ast.java Type.java
# 	$(JCC) $(JFLAGS) $<

# CMM.jlex.java: CMM.jlex sym.class
# 	$(JVM) $(CPFLAGS) JLex.Main $<

# sym.java: CMM.cup
# 	$(JVM) $(CPFLAGS) java_cup.Main < $<

# Sym.class: Type.java ast.java

# SymTable.class: Sym.java DuplicateSymException.java EmptySymTableException.java

###
# clean
###
clean:
	$(RM) $(RMFLAGS) $(RMTARGETS)
