open Std
open Dom_html
open Html

let render ~dispatch =
  let open Opt.O in
  let handle_key_down evt =
    if evt##.keyCode = 13 (* ENTER key pressed. *)
    then
      (let* target = evt##.target in
       let+ input = CoerceTo.input target in
       let todo = Js.to_string input##.value |> Todo.create in
       todo, fun () -> input##.value := Js.string "")
      |> fun o ->
      Opt.iter o (fun (todo, reset) ->
          dispatch @@ Some (Action.Add todo);
          reset ())
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
