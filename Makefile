parser: mini_l.l mini_l.yy
	bison -v -d --file-prefix=parser mini_l.yy
	flex mini_l.l
	g++ -std=c++11 -g -o parser parser.tab.cc lex.yy.c -lfl

clean:
	rm -f lex.yy.c parser.tab.* parser.output *.o parser location.hh position.hh stack.hh 
