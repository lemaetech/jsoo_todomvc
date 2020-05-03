open Js_of_ocaml_tyxml.Tyxml_js
open Js_of_ocaml

let new_todo =
  Html5.(
    header
      ~a:[a_class ["header"]]
      [ h1 [txt "todos"]
      ; input
          ~a:
            [ a_class ["new-todo"]; a_placeholder "What needs to be done?"
            ; a_autofocus () ]
          () ])

let main_section =
  let open Html5 in
  let toggle_all_chkbox =
    input
      ~a:[a_id "toggle-all"; a_class ["toggle-all"]; a_input_type `Checkbox]
      () in
  let toggle_all_lbl =
    label ~a:[a_label_for "toggle-all"] [txt "Mark all as complete"] in
  let todo_list = ul ~a:[a_class ["todo-list"]] [] in
  let footer_section =
    footer
      ~a:[a_class ["footer"]]
      [ span ~a:[a_class ["todo-count"]] []
      ; ul
          ~a:[a_class ["filters"]]
          [ li [a ~a:[a_href "#/"] [txt "All"]]
          ; li [a ~a:[a_href "#/active"] [txt "Active"]]
          ; li [a ~a:[a_href "#/completed"] [txt "Completed"]] ] ] in
  section
    ~a:[a_class ["main"]; a_style "display:none"]
    [toggle_all_chkbox; toggle_all_lbl; todo_list; footer_section]

let todo_app = Html5.(section ~a:[a_class ["todoapp"]] [new_todo; main_section])

let info_footer =
  Html5.(
    footer
      ~a:[a_class ["info"]]
      [ p [txt "Double click to edit a todo"]
      ; p
          [ txt "Written by "
          ; a ~a:[a_href "http://github.com/bikallem/"] [txt "Bikal Lem"] ]
      ; p [txt "Part of "; a ~a:[a_href "http://todomvc.com"] [txt "TodoMVC"]]
      ])

let main _ =
  Firebug.console##log info_footer ;
  let app = Dom_html.getElementById "app" in
  Dom.appendChild app (To_dom.of_section todo_app) ;
  Dom.appendChild app (To_dom.of_footer info_footer) ;
  Js.bool true

let () =
  let onload_handler = Dom.handler main in
  Dom_html.window##.onload := onload_handler
