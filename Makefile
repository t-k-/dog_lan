all: dog

# add flex library (libfl) to avoid undefined 
# reference to `yywrap'.
dog: dog.tab.o lex.yy.o 
	gcc $^ -lfl -o $@ 

%.o: %.c
	gcc -c -o $@ $^

lex.yy.c: dog.l dog.tab.h 
	flex dog.l
	
# two targets with the same rule:
dog.tab.h dog.tab.c: dog.y 
	bison -d dog.y

clean:
	find . \( ! -type d \) -a ! \( -name "*.y" -o -name "*.l" -o -name "Makefile" -o -name "*.swp" -o -name "*.md" -o -name "*.dog" \) | xargs rm -f
