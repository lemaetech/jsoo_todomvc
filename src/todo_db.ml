open Std

type t =
  { rh : Todo.t RList.handle
  ; rl : Todo.t RList.t
  }

let create todos =
  let rl, rh = RList.create todos in
  { rl; rh }

let add t todo = RList.snoc todo t.rh
let todos t = RList.value t.rl
let rl t = t.rl
