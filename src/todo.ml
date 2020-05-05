open Js_of_ocaml_tyxml.Tyxml_js
open Html

type t =
  { todo : string
  ; completed : bool
  ; id : Uuidm.t
  }

let create : ?completed:bool -> string -> t =
 fun ?(completed = false) todo -> { todo; completed; id = Uuidm.create `V4 }

let completed t = t.completed

let render t =
  let li_attrs = if completed t then [ a_class [ "completed" ] ] else [] in
  let input_attrs =
    [ a_class [ "toggle" ]; a_input_type `Checkbox ]
    |> fun attrs -> if completed t then a_checked () :: attrs else attrs
  in
  li
    ~a:li_attrs
    [ input ~a:input_attrs ()
    ; label [ txt t.todo ]
    ; button ~a:[ a_class [ "destroy" ] ] []
    ]
