open Std
open Html

type t =
  { filter_s: filter React.S.t (* filter change signal. *)
  ; change_filter: filter -> unit (* change current filter. *) }

let filter_s t = t.filter_s

let current_filter () =
  let frag = Url.Current.get_fragment () in
  let frag = if String.equal frag "" then "/" else frag in
  String.split_on_char '/' frag
  |> List.filter (String.equal "" >> not)
  |> List.map String.lowercase_ascii
  |> function
  | "active" :: _ -> `Active | "completed" :: _ -> `Completed | [] | _ -> `All

let configure_onfilterchange change_filter =
  let handle_hashchange (_ : #Dom_html.hashChangeEvent Js.t) =
    current_filter () |> change_filter ;
    Js._true in
  Dom_html.window##.onhashchange := Dom_html.handler @@ handle_hashchange

let create () =
  let filter_s, change_filter = React.S.create @@ current_filter () in
  configure_onfilterchange change_filter ;
  {filter_s; change_filter}

let filter_link lbl url filter t =
  a
    ~a:
      [ a_href url
      ; R.filter_attrib
          (a_class ["selected"])
          (React.S.map (( = ) filter) t.filter_s) ]
    [txt lbl]

let render t totals ~dispatch =
  let items_left_txt =
    React.S.map
      (fun {remaining; _} ->
        Printf.sprintf "%i %s left" remaining
          (if remaining <= 1 then "item" else "items"))
      totals in
  footer
    ~a:[a_class ["footer"]]
    [ span ~a:[a_class ["todo-count"]] [R.Html.txt items_left_txt]
    ; ul
        ~a:[a_class ["filters"]]
        [ li [filter_link "All" "#/" `All t]
        ; li [filter_link "Active" "#/active" `Active t]
        ; li [filter_link "Completed" "#/completed" `Completed t] ]
    ; button
        ~a:
          [ a_class ["clear-completed"]
          ; R.filter_attrib (a_style "display:none")
              (React.S.map (fun {completed; _} -> completed <= 0) totals)
          ; a_onclick (fun _ ->
                dispatch @@ Some `Clear_completed ;
                true) ]
        [txt "Clear completed"] ]
