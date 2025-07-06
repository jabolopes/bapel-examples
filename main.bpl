module main

imports {
  bapel.core
  game
}

type Player = struct {}

fn update () -> () {
  let delay: i64 = 16
  let e : std.optional (Entity, Player) = iterateAny [Player] ()
  ()
}

fn main() -> i32 {
  let material: Material = newRect (100, 100, 50, 50)
  let e1: Entity = init2 [Player, Material] (add (), struct {}, material)

  setUpdate update
  gameInit ()
  0
}
