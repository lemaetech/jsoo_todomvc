open Std

type t

val create : ?complete:bool -> ?id:Uuidm.t -> string -> t
val complete : t -> bool
val active : t -> bool
val id : t -> Uuidm.t
val set_complete : t -> complete:bool -> t
val to_json : t -> Js.js_string Js.t
val of_json : Js.js_string Js.t -> (t, string) result

val render :
     t
  -> dispatch:([> `Update of t | `Destroy of t] option -> unit)
  -> filter_s:filter React.S.t
  -> [> Html_types.li] Html.elt
