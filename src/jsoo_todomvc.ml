open Std
open Html

module Indextbl = Hashtbl.Make (struct
  type t = Uuidm.t

  let equal = Uuidm.equal
  let hash (u : Uuidm.t) = Hashtbl.hash u
end)

type t =
  { rl : Todo.t RList.t
  ; rh : Todo.t RList.handle
  ; total_s : totals React.S.t (* Monitors total todos. *)
  ; index_tbl : int Indextbl.t
  }

let total_remaining_todos todos =
  todos |> List.filter (fun todo -> not @@ Todo.completed todo) |> List.length

let create todos =
  let rl, rh = RList.create todos in
  let index_tbl = Indextbl.create (List.length todos) in
  List.iteri (fun i todo -> Indextbl.replace index_tbl (Todo.id todo) i) todos;
  let total_s, set_total =
    let total = List.length todos in
    let remaining = total_remaining_todos todos in
    let completed = total - remaining in
    React.S.create { total; completed; remaining }
  in
  (* Update total completed value whenever todos change. *)
  let (_ : unit React.event) =
    RList.event rl
    |> React.E.map (fun _ ->
           let todos = RList.value rl in
           let total = List.length todos in
           let remaining = total_remaining_todos todos in
           let completed = total - remaining in
           set_total { total; completed; remaining })
  in
  { rl; rh; index_tbl; total_s }

let update_index t =
  let todos = RList.value t.rl in
  List.iteri (fun i todo -> Indextbl.replace t.index_tbl (Todo.id todo) i) todos

let update_state t action =
  let do_if_index_found todo f =
    Todo.id todo |> Indextbl.find_opt t.index_tbl |> Option.iter f
  in
  match action with
  | `Add todo ->
    RList.snoc todo t.rh;
    update_index t
  | `Update todo -> do_if_index_found todo (fun index -> RList.update todo index t.rh)
  | `Destroy todo ->
    do_if_index_found todo (fun index -> RList.remove index t.rh);
    update_index t
  | `Clear_completed ->
    Log.console##log (Js.string "Clear_completed");
    let todos =
      RList.value t.rl |> List.filter (fun todo -> not @@ Todo.completed todo)
    in
    RList.set t.rh todos;
    update_index t

let main_section t dispatch =
  let todo_ul =
    R.Html.ul ~a:[ a_class [ "todo-list" ] ] @@ RList.map (Todo.render ~dispatch) t.rl
  in
  let toggle_all_chkbox =
    input ~a:[ a_id "toggle-all"; a_class [ "toggle-all" ]; a_input_type `Checkbox ] ()
  in
  let toggle_all_lbl =
    label ~a:[ a_label_for "toggle-all" ] [ txt "Mark all as complete" ]
  in
  section
    ~a:
      [ a_class [ "main" ]
      ; R.filter_attrib
          (a_style "display:none")
          (React.S.map (fun { total; _ } -> total = 0) t.total_s)
      ]
    [ toggle_all_chkbox; toggle_all_lbl; todo_ul; Footer.render t.total_s ~dispatch ]

let info_footer =
  footer
    ~a:[ a_class [ "info" ] ]
    [ p [ txt "Double click to edit a todo" ]
    ; p
        [ txt "Written by "
        ; a ~a:[ a_href "http://github.com/bikallem/" ] [ txt "Bikal Lem" ]
        ]
    ; p [ txt "Part of "; a ~a:[ a_href "http://todomvc.com" ] [ txt "TodoMVC" ] ]
    ]

let main todos (_ : #Dom_html.event Js.t) =
  let t = create todos in
  let action_s, dispatch = React.S.create None in
  let (_ : unit option React.S.t) = React.S.map (Option.map @@ update_state t) action_s in
  let todo_app =
    section
      ~a:[ a_class [ "todoapp" ] ]
      [ New_todo.render ~dispatch; main_section t dispatch ]
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
