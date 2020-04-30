(lang dune 2.5)

(name jsoo_todomvc)

(version 1.0.0)

(generate_opam_files true)

(source
 (github bikallem/jsoo_todomvc))

(license MPL-2.0)

(authors "Bikal Lem")

(maintainers "Bikal Lem")

(package
 (name jsoo_todomvc)
 (synopsis "TODO MVC app in js_of_ocaml")
 (description "Uses js_of_ocaml provided libraries only.")
 (depends
  (ocaml
   (>= 4.10.0))
  (dune
   (>= 2.5))
  (merlin
   (>= 3.3.4))
  (ocamlformat
   (>= 0.14.1))
  (utop
   (>= 2.5.0))
  (js_of_ocaml
   (>= 3.6.0))
  (js_of_ocaml-ppx
   (>= 3.6.0))
  (js_of_ocaml-lwt
   (>= 3.6.0))
  (js_of_ocaml-ppx_deriving_json
   (>= 3.6.0))
  (js_of_ocaml-tyxml
   (>= 3.6.0))))
