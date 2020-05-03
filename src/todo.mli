open Js_of_ocaml_tyxml.Tyxml_js

type t

val create : ?completed:bool -> string -> t
val render : t -> [> Html_types.li ] Html5.elt
