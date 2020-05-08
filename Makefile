b build:  
	dune b

p prod : 
	dune b --profile release

f fmt : 
	dune build @fmt --auto-promote

c clean : 
	dune clean 

lock : 
	opam lock .

dev-install :
	opam install . --locked --deps-only --working-dir 

dev-switch : 
	opam switch create -y . --deps-only --with-test --locked
	opam install -y . --locked --deps-only

open :
	xdg-open _build/default/src/index.html

.PHONY: b build p prod f fmt c clean lock dev-install dev-switch open 
