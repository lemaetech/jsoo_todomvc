open Std

type t

val create : ?complete:bool -> string -> t
val complete : t -> bool
val active : t -> bool
val id : t -> Uuidm.t
val set_complete : t -> complete:bool -> t

val render
  :  t
  -> dispatch:([> `Update of t | `Destroy of t ] option -> unit)
  -> filter_s:filter React.S.t
  -> [> Html_types.li ] Html.elt
