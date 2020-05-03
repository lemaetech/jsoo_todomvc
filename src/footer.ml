open Js_of_ocaml_tyxml.Tyxml_js.Html5
open Js_of_ocaml

let selected_attr frag =
  let frag' = Url.Current.get_fragment () in
  let frag' = if String.equal frag' "" then "/" else frag' in
  let frag' = String.trim frag' in
  Firebug.console##log (Js.string frag');
  if String.equal frag' frag then a_class [ "selected" ] else a_class []

let render todos =
  let todo_remaining_txt =
    todos
    |> List.filter (fun todo -> not @@ Todo.completed todo)
    |> List.length
    |> fun todo_count ->
    Printf.sprintf
      "%i %s left"
      todo_count
      (if todo_count = 1 then "item" else if todo_count > 1 then "items" else "")
  in
  footer
    ~a:[ a_class [ "footer" ] ]
    [ span ~a:[ a_class [ "todo-count" ] ] [ txt todo_remaining_txt ]
    ; ul
        ~a:[ a_class [ "filters" ] ]
        [ li [ a ~a:[ a_href "#/"; selected_attr "/" ] [ txt "All" ] ]
        ; li [ a ~a:[ a_href "#/active"; selected_attr "/active" ] [ txt "Active" ] ]
        ; li
            [ a
                ~a:[ a_href "#/completed"; selected_attr "/completed" ]
                [ txt "Completed" ]
            ]
        ]
    ; button
        ~a:[ a_class [ "clear-completed" ]; a_style "display:block" ]
        [ txt "Clear completed" ]
    ]
