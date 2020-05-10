open Std

type t

val create : unit -> t
val filter_s : t -> filter React.S.t

val render :
     t
  -> totals React.S.t
  -> dispatch:([> `Clear_completed] option -> unit)
  -> [> Html_types.footer] Html.elt
