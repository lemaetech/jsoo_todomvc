open Std
open Html

type t =
  { todo : string
  ; completed : bool
  ; id : Uuidm.t
  ; editing_s : bool React.signal
  ; set_editing : ?step:React.step -> bool -> unit
  }

let create ?(completed = false) todo =
  let editing_s, set_editing = React.S.create false in
  { todo; completed; id = Uuidm.create `V4; editing_s; set_editing }

let completed t = t.completed

let handle_dblclick t _ =
  t.set_editing true;
  true

let render t =
  let li_cls_attr =
    let cls_attr = if completed t then [ "completed" ] else [] in
    R.Html.a_class
    @@ React.S.map
         (function
           | true -> "editing" :: cls_attr
           | false -> cls_attr)
         t.editing_s
  in
  let input_attrs =
    [ a_class [ "toggle" ]; a_input_type `Checkbox ]
    |> fun attrs -> if completed t then a_checked () :: attrs else attrs
  in
  li
    ~a:[ li_cls_attr ]
    [ div
        ~a:[ a_class [ "view" ] ]
        [ input ~a:input_attrs ()
        ; label ~a:[ a_ondblclick @@ handle_dblclick t ] [ txt t.todo ]
        ; button ~a:[ a_class [ "destroy" ] ] []
        ]
    ; input ~a:[ a_class [ "edit" ]; a_value t.todo ] ()
    ]
