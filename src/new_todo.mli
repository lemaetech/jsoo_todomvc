open Std

val render : dispatch:(Action.t option -> unit) -> [> Html_types.header ] Html.elt
