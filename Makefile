b build:  
	dune b

p prod : 
	dune b --profile release

f fmt : 
	dune build @fmt --auto-promote

c clean : 
	dune clean 

install: 
	opam install . --deps-only --working-dir --with-test

dev-switch : 
	opam switch create . ocaml-base-compiler.4.10.0 --deps-only --with-test --working-dir

open :
	xdg-open _build/default/src/index.html

.PHONY: b build p prod f fmt c clean install dev-switch open 
