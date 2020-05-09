open Std

type t

val create : ?complete:bool -> string -> t
val complete : t -> bool
val id : t -> Uuidm.t
val set_complete : t -> complete:bool -> t

val render
  :  t
  -> dispatch:([> `Update of t | `Destroy of t ] option -> unit)
  -> [> Html_types.li ] Html.elt
