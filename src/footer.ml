open Std
open Html

let selected_attr frag =
  let frag' = Url.Current.get_fragment () in
  let frag' = if String.equal frag' "" then "/" else frag' in
  let frag' = String.trim frag' in
  if String.equal frag' frag then a_class [ "selected" ] else a_class []

let render total_completed_s =
  footer
    ~a:[ a_class [ "footer" ] ]
    [ span
        ~a:[ a_class [ "todo-count" ] ]
        [ R.Html.txt
          @@ React.S.map
               (fun total ->
                 Printf.sprintf
                   "%i %s left"
                   total
                   (if total <= 1 then "item" else if total > 1 then "items" else ""))
               total_completed_s
        ]
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
