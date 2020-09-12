open Std
open Dom_html
open Html

let handle_key_down dispatch evt =
  let open Opt.O in
  if evt##.keyCode = enter_keycode then
    (let* target = evt##.target in
     let+ input = CoerceTo.input target in
     let todo = Js.to_string input##.value |> Todo.create in
     (todo, fun () -> input##.value := Js.string ""))
    |> fun o ->
    Opt.iter o (fun (todo, reset) ->
        `Add todo |> dispatch ;
        reset ())
  else () ;
  true

let render ~dispatch =
  header
    ~a:[a_class ["header"]]
    [ h1 [txt "todos"]
    ; input
        ~a:
          [ a_class ["new-todo"]
          ; a_placeholder "What needs to be done?"
          ; a_autofocus ()
          ; a_onkeydown @@ handle_key_down dispatch ]
        () ]
