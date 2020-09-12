open Std

type t

val create : unit -> (t, [> `Not_supported of string]) result
val get : t -> Js.js_string Js.t option
val put : t -> Js.js_string Js.t -> unit
