open Js_of_ocaml_tyxml
open Js_of_ocaml
module T = Tyxml_js

let () =
  let html = T.Html.(div [txt "Hello, world!"]) in
  let app = Dom_html.getElementById "app" in
  Dom.appendChild app (Tyxml_js.To_dom.of_div html)
