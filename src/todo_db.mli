open Std

type t

val create : Todo.t list -> t
val add : t -> Todo.t -> unit
val todos : t -> Todo.t list
val rl : t -> Todo.t RList.t
