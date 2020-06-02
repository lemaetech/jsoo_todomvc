include Js_of_ocaml

module Opt = struct
  include Js_of_ocaml.Js.Opt

  module O = struct
    let ( let* ) = bind

    let ( let+ ) = map

    let ( >>= ) = bind

    let ( >>| ) = map
  end
end

module Option = struct
  include Option

  let get ~default o = match o with Some a -> a | None -> default

  module O = struct
    let ( let* ) = bind

    let ( let+ ) o f = map f o

    let ( >>= ) = ( let* )

    let ( >>| ) = ( let+ )
  end
end

module Result = struct
  include Stdlib.Result

  module O = struct
    let ( let* ) = bind

    let ( let+ ) o f = map f o

    let ( >>= ) = ( let* )

    let ( >>| ) = ( let+ )
  end
end

module List = struct
  include Stdlib.List

  let fold_right f b l = List.fold_right f l b
end

module RList = ReactiveData.RList
module Html = Js_of_ocaml_tyxml.Tyxml_js.Html
module Dom_html = Js_of_ocaml.Dom_html
module R = Js_of_ocaml_tyxml.Tyxml_js.R
module To_dom = Js_of_ocaml_tyxml.Tyxml_js.To_dom
module Log = Js_of_ocaml.Firebug

type totals = { total : int; completed : int; remaining : int }

let[@inline] ( >> ) f g x = g (f x)

let enter_keycode = 13

let esc_keycode = 27

type filter = [ `All | `Active | `Completed ]
