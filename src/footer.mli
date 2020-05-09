open Std

val render
  :  totals React.S.t
  -> dispatch:([> `Clear_completed ] option -> unit)
  -> filter_s:filter React.S.t
  -> [> Html_types.footer ] Html.elt
