CFLAGS+= -std=c99 -pedantic -Wall
CXXFLAGS+= -std=c++11 -pedantic -Wall
YFLAGS=
LDLIBS+= -ll -ly

all: transform

transform: parse.o
	${LINK.c} parse.o ${LDLIBS} -o $@

parse.o: lex.c parse.c

lsv_transform: lsv_parse.o
	${LINK.c} lsv_parse.o ${LDLIBS} -o $@

lsv_parse.o: lsv_lex.c lsv_parse.c

test: make_test transform lsv_transform
	./make_test 
	./transform input.vsl  
	./lsv_transform output

clean:
	rm -f lex.c parse.c parse.o transform
	rm -f lsv_lex.c lsv_parse.c lsv_parse.o lsv_transform
	rm -f make_test

.PHONY: all clean test

