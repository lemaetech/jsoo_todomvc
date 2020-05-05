open Js_of_ocaml
open Std

let main_section : Todo.t RList.t -> [> Html_types.section ] Html.elt =
 fun rl ->
  let open Html in
  let todos = RList.value rl in
  let todo_ul = R.Html.ul ~a:[ a_class [ "todo-list" ] ] @@ RList.map Todo.render rl in
  let toggle_all_chkbox =
    input ~a:[ a_id "toggle-all"; a_class [ "toggle-all" ]; a_input_type `Checkbox ] ()
  in
  let toggle_all_lbl =
    label ~a:[ a_label_for "toggle-all" ] [ txt "Mark all as complete" ]
  in
  let visibility = if List.length todos > 0 then "" else "display:none" in
  section
    ~a:[ a_class [ "main" ]; a_style visibility ]
    [ toggle_all_chkbox; toggle_all_lbl; todo_ul; Footer.render todos ]

let info_footer =
  Html.(
    footer
      ~a:[ a_class [ "info" ] ]
      [ p [ txt "Double click to edit a todo" ]
      ; p
          [ txt "Written by "
          ; a ~a:[ a_href "http://github.com/bikallem/" ] [ txt "Bikal Lem" ]
          ]
      ; p [ txt "Part of "; a ~a:[ a_href "http://todomvc.com" ] [ txt "TodoMVC" ] ]
      ])

let main _ =
  Firebug.console##log info_footer;
  let appElem = Dom_html.getElementById "app" in
  let todos =
    [ true, "Buy a unicorn"; false, "Eat haagen daz ice-cream, yummy!" ]
    |> List.map (fun (completed, todo) -> Todo.create ~completed todo)
  in
  let rl, rhandle = RList.create todos in
  let todo_app =
    Html.(
      section ~a:[ a_class [ "todoapp" ] ] [ New_todo.render rhandle; main_section rl ])
  in
  Dom.appendChild appElem (To_dom.of_section todo_app);
  Dom.appendChild appElem (To_dom.of_footer info_footer);
  Js.bool true

let () =
  let onload_handler = Dom.handler main in
  Dom_html.window##.onload := onload_handler
