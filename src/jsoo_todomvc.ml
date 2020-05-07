open Std

type t =
  { rl : Todo.t RList.t
  ; rh : Todo.t RList.handle
  }

let create todos =
  let rl, rh = RList.create todos in
  { rl; rh }

let update_state t = function
  | Action.Add todo -> RList.snoc todo t.rh
  | Action.Update _todo -> ()

let main_section rl =
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

let main todos (_ : #Dom_html.event Js.t) =
  let t = create todos in
  let action_s, dispatch = React.S.create None in
  let _ = React.S.map (Option.map @@ update_state t) action_s in
  let todo_app =
    Html.(
      section
        ~a:[ a_class [ "todoapp" ] ]
        [ New_todo.render ~dispatch; main_section t.rl ])
  in
  let appElem = Dom_html.getElementById "app" in
  [ To_dom.of_section todo_app; To_dom.of_footer info_footer ]
  |> List.iter (fun elem -> Dom.appendChild appElem elem);
  Js.bool true

let () =
  let todos =
    [ true, "Buy a unicorn"; false, "Eat haagen daz ice-cream, yummy!" ]
    |> List.map (fun (completed, todo) -> Todo.create ~completed todo)
  in
  Dom_html.window##.onload := Dom_html.handler @@ main todos
