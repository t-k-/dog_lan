# add flex library (libfl) to avoid undefined 
# reference to `yywrap'.
dogcc.out: dog.tab.o lex.yy.o 
	gcc $^ -lfl -o $@ 

%.o: %.c
	gcc -c -o $@ $^

lex.yy.c: dog.l dog.tab.h 
	flex dog.l
	
# two targets with the same rule:
dog.tab.h dog.tab.c: dog.y 
	bison --report itemset -d dog.y

clean:
	rm -f *.out
	rm -f *.o
	rm -f *.tab.[ch]
	rm -f *.output
	rm -f *.yy.c
	rm -f *.yy.c
