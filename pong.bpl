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

type Dir = struct{dir sdl::FPoint}
type Motion = struct{delta sdl::FPoint}

fn init() -> () {
  initPlayerInput ()

  let v: f32 = 0

  let lpadMaterial = newRect (100, 100, 10, 50)
  let lpad = ecs::init3 [Lpad, Material, Motion] (ecs::add (), struct{}, lpadMaterial, struct{delta = struct{x = v, y = v}})

  let rpadMaterial = newRect (500, 100, 10, 50)
  let rpad = ecs::init3 [Rpad, Material, Motion] (ecs::add (), struct{}, rpadMaterial, struct{delta = struct{x = v, y = v}})

  let ballMaterial = newRect (200, 100, 10, 10)
  setAnchor (ballMaterial, struct{x = 0.5, y = 0.5})
  let ballDir: Dir = struct{dir = struct{x = 1, y = 0}}
  let ball = ecs::init3 [Ball, Material, Dir] (ecs::add (), struct{}, ballMaterial, ballDir)

  ()
}

fn setPadMaterial(padID: Entity, material: Material) -> () {
  let rect = getDstRect material
  if rect.y < 0 {
    rect <- set rect {y = 0}
  } else {
    let d = windowSizeF.y - rect.h
    if rect.y > d {
      rect <- set rect {y = d}
    }
  }

  setDstRect (material, rect)
  ecs::set (padID, material)
}

fn getPadRect['a]() -> sdl::FRect {
  let pad = ecs::joinAny ['a, Material] ()
  if !has_value pad {
    return emptyFRect ()
  }

  let material = (get_value [(Entity, 'a, Material)] pad).2
  getDstRect material
}

fn getPadMotion['a]() -> sdl::FPoint {
  let pad = ecs::joinAny ['a, Motion] ()
  if !has_value [(Entity, 'a, Motion)] pad {
    return struct{x = 0, y = 0}
  }

  (get_value [(Entity, 'a, Motion)] pad).2.delta
}

fn updatePads(deltaTime: f32) -> () {
  let velocity: f32 = 0.6

  let lpad = ecs::joinAny [Lpad, Material] ()
  if !has_value [(Entity, Lpad, Material)] lpad {
    return ()
  }

  let rpad = ecs::getAny [Rpad] ()
  if !has_value [(Entity, Rpad)] rpad {
    return ()
  }

  let lpadID = (get_value [(Entity, Lpad, Material)] lpad).0
  let lpadMaterial = (get_value [(Entity, Lpad, Material)] lpad).2

  let rpadID = (get_value [(Entity, Rpad)] rpad).0

  let input = getPlayerInput ()
  let y: f32 = 0
  if input.up {
    y <- -velocity * deltaTime
  } else if input.down {
    y <- velocity * deltaTime
  }

  let motion: Motion = struct{delta = struct{x = 0, y = y}}
  ecs::set [Motion] (lpadID, motion)
  ecs::set [Motion] (rpadID, motion)
}

fn updateBall(deltaTime: f32) -> () {
  let velocity: f32 = 0.3

  let ball = ecs::join3Any [Ball, Material, Dir] ()
  if !has_value [(Entity, Ball, Material, Dir)] ball {
    return ()
  }

  let ballID = (get_value [(Entity, Ball, Material, Dir)] ball).0
  let material = (get_value [(Entity, Ball, Material, Dir)] ball).2
  let ballDir = (get_value [(Entity, Ball, Material, Dir)] ball).3

  let rect = getDstRect material
  let pos = struct{x = rect.x, y = rect.y}

  let posDelta: sdl::FPoint = struct{
    x = velocity * ballDir.dir.x * deltaTime,
    y = velocity * ballDir.dir.y * deltaTime,
  }

  let newPos: sdl::FPoint = struct{
    x = rect.x + posDelta.x,
    y = rect.y + posDelta.y,
  }

  rect <- set rect {
    x = newPos.x,
    y = newPos.y,
  }

  let newDir = ballDir.dir

  if posDelta.y < 0 && lineSegmentCrossesHLine (pos, newPos, 0) {
    rect <- set rect {y = 0}
    newDir <- set newDir {y = core::abs newDir.y}
  } else {
    let d: f32 = windowSizeF.y - rect.h
    if posDelta.y > 0 && lineSegmentCrossesHLine (pos, newPos, d) {
      rect <- set rect {y = d}
      newDir <- set newDir {y = - core::abs newDir.y}
    }
  }

  if posDelta.x < 0 && lineSegmentCrossesVLine (pos, newPos, 0) {
    rect <- set rect {x = 150, y = windowSizeF.y / 2}
    newDir <- struct{x = 1, y = 0.1}
  } else {
    let d: f32 = windowSizeF.x - rect.w
    if posDelta.x > 0 && lineSegmentCrossesVLine (pos, newPos, d) {
      rect <- set rect {x = windowSizeF.x - 150, y = windowSizeF.y / 2}
      newDir <- struct{x = -1, y = -0.1}
    }
  }

  {
    let lpadRect = getPadRect [Lpad] ()
    let padMotion = getPadMotion [Lpad] ()
    let newRelativePos: sdl::FPoint = struct{
      x = newPos.x - padMotion.x,
      y = newPos.y - padMotion.y,
    }

    let intersection: sdl::FPoint = struct{x = 0, y = 0}
    let bounce: sdl::FPoint = struct{x = 0, y = 0}
    let ok = false
    (intersection, bounce, ok) <- lineSegmentCrossesRect (pos, newRelativePos, lpadRect)
    if ok {
      rect <- set rect {x = intersection.x, y = intersection.y}
      newDir <- set newDir {
        x = bounce.x,
        y = clamp(bounce.y, -0.5, 0.5),
      }
    }
  }

  {
    let rpadRect = getPadRect [Rpad] ()
    let padMotion = getPadMotion [Rpad] ()
    let newRelativePos: sdl::FPoint = struct{
      x = newPos.x - padMotion.x,
      y = newPos.y - padMotion.y,
    }

    let intersection: sdl::FPoint = struct{x = 0, y = 0}
    let bounce: sdl::FPoint = struct{x = 0, y = 0}
    let ok = false
    (intersection, bounce, ok) <- lineSegmentCrossesRect (pos, newRelativePos, rpadRect)
    if ok {
      rect <- set rect {x = intersection.x, y = intersection.y}
      newDir <- set newDir {
        x = velocity * bounce.x,
        y = clamp(bounce.y, -0.5, 0.5),
      }
    }
  }

  setDstRect(material, rect)
  ballDir <- set ballDir {dir = normalize newDir}

  ecs::set2 [Material, Dir] (ballID, material, ballDir)
}

fn movePad['a]() -> () {
  let pad = ecs::join3Any ['a, Material, Motion] ()
  if !has_value [(Entity, 'a, Material, Motion)] pad {
    return ()
  }

  let padID = (get_value [(Entity, 'a, Material, Motion)] pad).0
  let material = (get_value [(Entity, 'a, Material, Motion)] pad).2
  let motion = (get_value [(Entity, 'a, Material, Motion)] pad).3

  let rect = getDstRect material
  rect <- set rect {
    x = rect.x + motion.delta.x,
    y = rect.y + motion.delta.y,
  }
  setDstRect(material, rect)

  setPadMaterial (padID, material)
}

fn update () -> () {
  let deltaTime: f32 = 16
  updatePads deltaTime
  updateBall deltaTime
  movePad [Lpad] ()
  movePad [Rpad] ()
  ()
}

pub fn pong::start() -> i64 {
  init ()

  let options: GameOptions = struct{windowSize = windowSize, keyboardHandler = updatePlayerInput, updateHandler = update}
  gameInit options
}
