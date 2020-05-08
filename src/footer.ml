open Std
open Html

let selected_attr frag =
  let frag' = Url.Current.get_fragment () in
  let frag' = if String.equal frag' "" then "/" else frag' in
  let frag' = String.trim frag' in
  if String.equal frag' frag then a_class [ "selected" ] else a_class []

let render totals ~dispatch =
  let items_left_txt =
    React.S.map
      (fun { remaining; _ } ->
        Printf.sprintf
          "%i %s left"
          remaining
          (if remaining <= 1 then "item" else if remaining > 1 then "items" else ""))
      totals
  in
  footer
    ~a:[ a_class [ "footer" ] ]
    [ span ~a:[ a_class [ "todo-count" ] ] [ R.Html.txt items_left_txt ]
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
        ~a:
          [ a_class [ "clear-completed" ]
          ; R.filter_attrib
              (a_style "display:none")
              (React.S.map (fun { completed; _ } -> completed <= 0) totals)
          ; a_onclick (fun _ ->
                dispatch @@ Some `Clear_completed;
                true)
          ]
        [ txt "Clear completed" ]
    ]
