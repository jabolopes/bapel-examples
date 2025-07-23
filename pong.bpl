module pong

imports {
  bapel.core
  game
}

impls {
  "pong_options.ccm"
  "pong_input.bpl"
  "pong_collisions.bpl"
}

type Lpad = struct{}
type Rpad = struct{}
type Ball = struct{}

type Pos = struct{pos sdl.FPoint}
type Dir = struct{dir sdl.FPoint}

fn init() -> () {
  initPlayerInput ()

  let lpadMaterial: Material = newRect (100, 100, 10, 30)
  let lpad: Entity = ecs.init2 [Lpad, Material] (ecs.add (), struct{}, lpadMaterial)

  let rpadMaterial: Material = newRect (500, 100, 10, 30)
  let rpad: Entity = ecs.init2 [Rpad, Material] (ecs.add (), struct{}, rpadMaterial)

  let ballMaterial: Material = newRect (200, 100, 10, 10)
  let ballDir: Dir = struct{dir = struct{x = 1, y = 2}}
  let ball: Entity = ecs.init3 [Ball, Material, Dir] (ecs.add (), struct{}, ballMaterial, ballDir)

  ()
}

fn setPadMaterial(padID: Entity, material: Material) -> () {
  let rect: sdl.FRect = getDstRect material
  if rect->y < 0 {
    rect <- set rect {y = 0}
  } else {
    let d: f32 = windowSizeF->y - rect->h
    if rect->y > d {
      rect <- set rect {y = d}
    }
  }

  setDstRect (material, rect)
  ecs.set (padID, material)
}

fn updatePads(deltaTime: f32) -> () {
  let velocity: f32 = 0.8

  let lpad: std.optional (Entity, Lpad, Material) = ecs.joinAny [Lpad, Material] ()
  if !has_value [(Entity, Lpad, Material)] lpad {
    return ()
  }

  let rpad: std.optional (Entity, Rpad, Material) = ecs.joinAny [Rpad, Material] ()
  if !has_value [(Entity, Rpad, Material)] rpad {
    return ()
  }

  let lpadID: Entity = (get_value [(Entity, Lpad, Material)] lpad)->0
  let lpadMaterial: Material = (get_value [(Entity, Lpad, Material)] lpad)->2

  let rpadID: Entity = (get_value [(Entity, Rpad, Material)] rpad)->0
  let rpadMaterial: Material = (get_value [(Entity, Rpad, Material)] rpad)->2

  let input: PlayerInput = getPlayerInput ()
  if input->up {
    let y: f32 = getY lpadMaterial - velocity * deltaTime
    setY (lpadMaterial, y)
  } else {
    if input->down {
      let y: f32 = getY lpadMaterial + velocity * deltaTime
      setY (lpadMaterial, y)
    }
  }

  let rect: sdl.FRect = getDstRect rpadMaterial
  rect <- set rect {y = (getDstRect lpadMaterial)->y}
  setDstRect(rpadMaterial, rect)

  setPadMaterial (lpadID, lpadMaterial)
  setPadMaterial (rpadID, rpadMaterial)
}

fn updateBall(deltaTime: f32) -> () {
  let velocity: f32 = 0.1

  let ball: std.optional (Entity, Ball, Material, Dir) = ecs.join3Any [Ball, Material, Dir] ()
  if !has_value [(Entity, Ball, Material, Dir)] ball {
    return ()
  }

  let ballID: Entity = (get_value [(Entity, Ball, Material, Dir)] ball)->0
  let material: Material = (get_value [(Entity, Ball, Material, Dir)] ball)->2
  let ballDir: Dir = (get_value [(Entity, Ball, Material, Dir)] ball)->3

  let rect: sdl.FRect = getDstRect material
  let pos: sdl.FPoint = struct{x = rect->x, y = rect->y}
  rect <- set rect {
    x = rect->x + velocity * ballDir->dir->x * deltaTime,
    y = rect->y + velocity * ballDir->dir->y * deltaTime,
  }

  let newPos: sdl.FPoint = struct{x = rect->x, y = rect->y}
  let newDir: sdl.FPoint = ballDir->dir

  if lineSegmentCrossesHLine(pos, newPos, 0) {
    rect <- set rect {y = 0}
    newDir <- set newDir {y = -newDir->y}
  } else {
    let d: f32 = windowSizeF->y - rect->h
    if lineSegmentCrossesHLine(pos, newPos, d) {
      rect <- set rect {y = d}
      newDir <- set newDir {y = -newDir->y}
    }
  }

  if lineSegmentCrossesVLine(pos, newPos, 0) {
    rect <- set rect {x = 0}
    newDir <- set newDir {x = -newDir->x}
  } else {
    let d: f32 = windowSizeF->x - rect->w
    if lineSegmentCrossesVLine(pos, newPos, d) {
      rect <- set rect {x = d}
      newDir <- set newDir {x = -newDir->x}
    }
  }

  setDstRect(material, rect)
  ballDir <- set ballDir {dir = newDir}

  ecs.set2 [Material, Dir] (ballID, material, ballDir)
}

fn update () -> () {
  let deltaTime: f32 = 16
  updatePads deltaTime
  updateBall deltaTime
  ()
}

export fn pong.start() -> i64 {
  init ()

  let options: GameOptions = struct{windowSize = windowSize, keyboardHandler = updatePlayerInput, updateHandler = update}
  gameInit options
}
