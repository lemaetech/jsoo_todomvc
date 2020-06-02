open Std
open Result.O

type t = Dom_html.storage Js.t

let key = Js.string "jsoo-todomvc"

let get t = t##getItem key |> Js.Opt.to_option

let put t s = t##setItem key s

let create () =
  let* storage =
    Js.Optdef.case
      Dom_html.window##.localStorage
      (fun () ->
        Result.error
          (`Not_supported
            "HTML5 localStorage functionality not supported by this browser"))
      Result.ok
  in
  Ok storage
