open Std
open Html

let a_link lbl url filter filter_s =
  a
    ~a:
      [ a_href url
      ; R.filter_attrib (a_class [ "selected" ]) (React.S.map (( = ) filter) filter_s)
      ]
    [ txt lbl ]
;;

let render totals ~dispatch ~filter_s =
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
        [ li [ a_link "All" "#/" `All filter_s ]
        ; li [ a_link "Active" "#/active" `Active filter_s ]
        ; li [ a_link "Completed" "#/completed" `Completed filter_s ]
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
;;
