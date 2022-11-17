parser: tokenizer_v3.l phase2_v2.yy
	bison -v -d --file-prefix=parser phase2_v2.yy
	flex tokenizer_v3.l
	g++ -std=c++11 -g -o parser parser.tab.cc lex.yy.c -lfl

clean:
	rm -f lex.yy.c parser.tab.* parser.output *.o parser location.hh position.hh stack.hh 
