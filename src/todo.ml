open Std
open Html
open Dom_html

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

let handle_dblclick t todo_input _ =
  t.set_editing true;
  let dom_inp = To_dom.of_input todo_input in
  dom_inp##focus;
  true

let todo_input t =
  let open Opt.O in
  let handle_onblur _ =
    t.set_editing false;
    true
  in
  let handle_key_down evt =
    if evt##.keyCode = 13 (* ENTER *)
    then ()
    else if evt##.keyCode = 27 (* ESC *)
    then (
      t.set_editing false;
      evt##.target
      >>= CoerceTo.input
      |> fun o -> Opt.iter o (fun input -> input##.value := Js.string t.todo))
    else ();
    true
  in
  input
    ~a:
      [ a_id (Uuidm.to_string t.id)
      ; a_input_type `Text
      ; a_class [ "edit" ]
      ; a_value t.todo
      ; a_onblur @@ handle_onblur
      ; a_onkeydown @@ handle_key_down
      ]
    ()

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
  let todo_input = todo_input t in
  li
    ~a:[ li_cls_attr ]
    [ div
        ~a:[ a_class [ "view" ] ]
        [ input ~a:input_attrs ()
        ; label ~a:[ a_ondblclick @@ handle_dblclick t todo_input ] [ txt t.todo ]
        ; button ~a:[ a_class [ "destroy" ] ] []
        ]
    ; todo_input
    ]
