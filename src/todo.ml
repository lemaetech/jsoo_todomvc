open Std
open Html
open Dom_html

type t =
  { description : string
  ; complete : bool
  ; id : Uuidm.t
  ; editing_s : bool React.signal
  ; set_editing : ?step:React.step -> bool -> unit
  }

let create ?(complete = false) description =
  let editing_s, set_editing = React.S.create false in
  { description; complete; id = Uuidm.create `V4; editing_s; set_editing }
;;

let complete t = t.complete
let id t = t.id
let set_complete t ~complete = { t with complete }

let handle_dblclick t todo_input _ =
  t.set_editing true;
  let dom_inp = To_dom.of_input todo_input in
  dom_inp##focus;
  true
;;

let todo_input t dispatch =
  let open Opt.O in
  let reset_input input_elem =
    input_elem
    >>= CoerceTo.input
    |> fun o -> Opt.iter o (fun input -> input##.value := Js.string t.description)
  in
  let handle_onblur evt =
    t.set_editing false;
    reset_input evt##.target;
    true
  in
  let handle_key_down evt =
    if evt##.keyCode = enter_keycode
    then
      (t.set_editing false;
       let* target = evt##.target in
       let+ input = CoerceTo.input target in
       Js.to_string input##.value)
      |> fun o ->
      Opt.iter o (fun description ->
          `Update { t with description } |> (Option.some >> dispatch))
    else if evt##.keyCode = esc_keycode
    then (
      t.set_editing false;
      reset_input evt##.target)
    else ();
    true
  in
  input
    ~a:
      [ a_id (Uuidm.to_string t.id)
      ; a_input_type `Text
      ; a_class [ "edit" ]
      ; a_value t.description
      ; a_onblur @@ handle_onblur
      ; a_onkeydown @@ handle_key_down
      ]
    ()
;;

let render t ~dispatch =
  let li_cls_attr =
    let cls_attr = if complete t then [ "completed" ] else [] in
    R.Html.a_class
    @@ React.S.map
         (function
           | true -> "editing" :: cls_attr
           | false -> cls_attr)
         t.editing_s
  in
  let completed_toggler =
    let handle_onclick (_ : #Dom_html.event Js.t) =
      let t = { t with complete = not t.complete } in
      dispatch @@ Some (`Update t);
      true
    in
    input
      ~a:
        ([ a_class [ "toggle" ]; a_input_type `Checkbox; a_onclick handle_onclick ]
        |> fun attrs -> if complete t then a_checked () :: attrs else attrs)
      ()
  in
  let todo_input = todo_input t dispatch in
  let handle_destroy (_ : #Dom_html.event Js.t) =
    dispatch @@ Some (`Destroy t);
    true
  in
  li
    ~a:[ li_cls_attr ]
    [ div
        ~a:[ a_class [ "view" ] ]
        [ completed_toggler
        ; label ~a:[ a_ondblclick @@ handle_dblclick t todo_input ] [ txt t.description ]
        ; button ~a:[ a_class [ "destroy" ]; a_onclick handle_destroy ] []
        ]
    ; todo_input
    ]
;;
