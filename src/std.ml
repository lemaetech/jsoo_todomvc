module Opt = struct
  include Js_of_ocaml.Js.Opt

  module O = struct
    let ( let* ) = bind
    let ( let+ ) = map
    let ( >>= ) = bind
    let ( >>| ) = map
  end
end

module RList = ReactiveData.RList
module Html = Js_of_ocaml_tyxml.Tyxml_js.Html
module Dom_html = Js_of_ocaml.Dom_html
module R = Js_of_ocaml_tyxml.Tyxml_js.R
module To_dom = Js_of_ocaml_tyxml.Tyxml_js.To_dom