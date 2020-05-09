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
  ; mutable markall_completed : bool
  }

let update_index rl index_tbl =
  let todos = RList.value rl in
  List.iteri (fun i todo -> Indextbl.replace index_tbl (Todo.id todo) i) todos

let create todos =
  let calculate_totals rl =
    let todos = RList.value rl in
    let total = List.length todos in
    let remaining = todos |> List.filter (Todo.complete >> not) |> List.length in
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
  { rl; rh; index_tbl; total_s; markall_completed = false }

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
    RList.value t.rl |> List.filter (Todo.complete >> not) |> RList.set t.rh;
    update_index t.rl t.index_tbl
  | `Toggle_all toggle ->
    t.markall_completed <- toggle;
    RList.value t.rl |> List.map (Todo.set_complete ~complete:toggle) |> RList.set t.rh;
    update_index t.rl t.index_tbl

let main_section t dispatch =
  let (_ : unit React.signal) =
    React.S.map
      (fun { total; completed; _ } -> t.markall_completed <- total = completed)
      t.total_s
  in
  section
    ~a:
      [ a_class [ "main" ]
      ; R.filter_attrib
          (a_style "display:none")
          (React.S.map (fun { total; _ } -> total = 0) t.total_s)
      ]
    [ input
        ~a:
          [ a_id "toggle-all"
          ; a_class [ "toggle-all" ]
          ; a_input_type `Checkbox
          ; R.filter_attrib
              (a_checked ())
              (React.S.map (fun { total; completed; _ } -> total = completed) t.total_s)
          ; a_onclick (fun _ ->
                `Toggle_all (not t.markall_completed) |> (Option.some >> dispatch);
                true)
          ]
        ()
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
    |> List.map (fun (complete, todo) -> Todo.create ~complete todo)
  in
  Dom_html.window##.onload := Dom_html.handler @@ main todos
