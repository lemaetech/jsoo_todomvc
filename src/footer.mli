open Std

val render
  :  totals React.S.t
  -> dispatch:([> `Clear_completed ] option -> unit)
  -> [> Html_types.footer ] Html.elt
