open Js_of_ocaml_tyxml.Tyxml_js
open Js_of_ocaml

let () =
  let html = Html.(div [txt "Hello, world!"]) in
  let app = Dom_html.getElementById "app" in
  Dom.appendChild app (To_dom.of_div html)
