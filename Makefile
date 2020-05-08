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
	opam install . --locked --deps-only --working-dir --with-test

dev-switch : 
	opam switch create . ocaml-base-compiler.4.10.0 --deps-only --with-test --locked --working-dir

open :
	xdg-open _build/default/src/index.html

.PHONY: b build p prod f fmt c clean lock dev-install dev-switch open 
