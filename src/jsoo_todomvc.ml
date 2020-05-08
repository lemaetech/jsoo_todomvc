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
  ; total_s : totals React.S.t (* Monitors todo list totals. *)
  ; index_tbl : int Indextbl.t
  }

let update_index rl index_tbl =
  let todos = RList.value rl in
  List.iteri (fun i todo -> Indextbl.replace index_tbl (Todo.id todo) i) todos

let create todos =
  let calculate_totals rl =
    let todos = RList.value rl in
    let total = List.length todos in
    let remaining = todos |> List.filter (Todo.completed >> not) |> List.length in
    let completed = total - remaining in
    { total; completed; remaining }
  in
  let rl, rh = RList.create todos in
  let index_tbl = Indextbl.create (List.length todos) in
  update_index rl index_tbl;
  let total_s, set_total = React.S.create @@ calculate_totals rl in
  let (_ : unit React.event) =
    RList.event rl |> React.E.map (fun _ -> set_total @@ calculate_totals rl)
  in
  { rl; rh; index_tbl; total_s }

let update_state t action =
  let do_if_index_found todo f =
    Todo.id todo |> Indextbl.find_opt t.index_tbl |> Option.iter f
  in
  match action with
  | `Add todo ->
    RList.snoc todo t.rh;
    update_index t.rl t.index_tbl
  | `Update todo -> do_if_index_found todo (fun index -> RList.update todo index t.rh)
  | `Destroy todo ->
    do_if_index_found todo (fun index -> RList.remove index t.rh);
    update_index t.rl t.index_tbl
  | `Clear_completed ->
    Log.console##log (Js.string "Clear_completed");
    let todos =
      RList.value t.rl |> List.filter (fun todo -> not @@ Todo.completed todo)
    in
    RList.set t.rh todos;
    update_index t.rl t.index_tbl

let main_section t dispatch =
  section
    ~a:
      [ a_class [ "main" ]
      ; R.filter_attrib
          (a_style "display:none")
          (React.S.map (fun { total; _ } -> total = 0) t.total_s)
      ]
    [ input ~a:[ a_id "toggle-all"; a_class [ "toggle-all" ]; a_input_type `Checkbox ] ()
    ; label ~a:[ a_label_for "toggle-all" ] [ txt "Mark all as complete" ]
    ; R.Html.ul ~a:[ a_class [ "todo-list" ] ] @@ RList.map (Todo.render ~dispatch) t.rl
    ; Footer.render t.total_s ~dispatch
    ]

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
