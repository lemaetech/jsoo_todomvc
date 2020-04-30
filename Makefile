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

.PHONY : install
install : 
	@opam switch create .

.PHONY : update
update :
	@opam install ./jsoo_todomvc.opam.locked --deps-only
