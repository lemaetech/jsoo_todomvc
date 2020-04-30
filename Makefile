.PHONY : b build # default target
b build:  # b or build 
	@dune b

.PHONY : p prod 
p prod : 
	@dune b --profile release

.PHONY : f fmt 
f fmt : 
	@dune build @fmt --auto-promote

.PHONY : c clean
c clean : 
	@dune clean 

.PHONY : lock
lock : 
	@opam lock .

.PHONY : install
install :
	@opam install . --locked --deps-only

.PHONY : switch 
switch : 
	@opam switch create . --locked --deps-only
