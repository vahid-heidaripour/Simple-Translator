#!/bin/sh

g++ make_test.cpp -o make_test

for i in 1 2 3 4 5 6 7 8 9 10
do
	make test
done

