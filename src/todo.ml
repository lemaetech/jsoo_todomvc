open Js_of_ocaml_tyxml.Tyxml_js
open Html5

type t =
  { todo : string
  ; completed : bool
  ; id : Uuidm.t
  }

let create : ?completed:bool -> string -> t =
 fun ?(completed = false) todo -> { todo; completed; id = Uuidm.create `V4 }

let completed t = t.completed

let render : t -> [> Html_types.li ] Html5.elt =
 fun t ->
  let completed_attr = if completed t then "completed" else "" in
  li
    ~a:[ a_class [ completed_attr ] ]
    [ input
        ~a:
          ([ a_class [ "toggle" ]; a_input_type `Checkbox ]
          |> fun attrs -> if completed t then a_checked () :: attrs else attrs)
        ()
    ; label [ txt t.todo ]
    ; button ~a:[ a_class [ "destroy" ] ] []
    ]
