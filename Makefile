.PHONY : build # default target
b build:  # b or build 
	dune b 

.PHONY : prod 
p prod : 
	dune b --profile release

.PHONY : fmt 
f fmt : 
	dune build @fmt --auto-promote

.PHONY : clean
c clean : 
	dune clean 
