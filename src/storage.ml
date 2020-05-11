open Std
open Result.O

type t = {storage: Dom_html.storage Js.t}

let key = Js.string "jsoo-todomvc"
let get t = t.storage##getItem key |> Js.Opt.to_option
let put t s = t.storage##setItem key s

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
  Ok {storage}
