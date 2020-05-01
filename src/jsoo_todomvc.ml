open Js_of_ocaml_tyxml.Tyxml_js
open Js_of_ocaml

let () =
  let now = new%js Js.date_now in
  let date = now##toString in
  let s = Js.to_string date ^ " : Hello world!" in
  let html = Html.(div [txt s]) in
  let app = Dom_html.getElementById "app" in
  Dom.appendChild app (To_dom.of_div html)
