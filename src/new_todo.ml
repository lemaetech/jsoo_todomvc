open Js_of_ocaml
open Std
open Dom_html
open Html

let render todo_rlist =
  let open Opt.O in
  let handle_key_down evt =
    if evt##.keyCode == 13 (* ENTER key pressed. *)
    then
      (let* target = evt##.target in
       let+ input = CoerceTo.input target in
       Js.to_string input##.value |> Todo.create)
      |> fun o -> Opt.iter o (fun todo -> RList.snoc todo todo_rlist)
    else ();
    true
  in
  header
    ~a:[ a_class [ "header" ] ]
    [ h1 [ txt "todos" ]
    ; input
        ~a:
          [ a_class [ "new-todo" ]
          ; a_placeholder "What needs to be done?"
          ; a_autofocus ()
          ; a_onkeydown handle_key_down
          ]
        ()
    ]
