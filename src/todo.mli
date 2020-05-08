open Std

type t

val create : ?completed:bool -> string -> t
val completed : t -> bool
val id : t -> Uuidm.t

val render
  :  t
  -> dispatch:([> `Update of t | `Destroy of t ] option -> unit)
  -> [> Html_types.li ] Html.elt
