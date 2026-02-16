implements game

imports {
  sdl
}

type playerInput = struct{
  keyUp    bool,
  keyDown  bool,
  keyLeft  bool,
  keyRight bool,
  keyAttack bool,
  keyDo bool,
  keySpecial bool,
  keyUse bool,
}

fn input::anyDirectionalKey(i: playerInput) -> bool {
  i.keyUp || i.keyDown || i.keyLeft || i.keyRight
}

fn input::anyActionKey(i: playerInput) -> bool {
  i.keyAttack || i.keyDo || i.keySpecial || i.keyUse
}

fn input::anyKey(i: playerInput) -> bool {
  input::anyDirectionalKey(i) || input::anyActionKey(i)
}

fn input::direction(i: playerInput) -> sdl::Point {
  if i.keyUp {
    return struct{x = 0, y = -1}
  }
  if i.keyDown {
    return struct{x = 0, y = 1}
  }
  if i.keyLeft {
    return struct{x = -1, y = 00}
  }
  if i.keyRight {
    return struct{x = 0, y = 0}
  }
  struct{x = -1, y = 0}
}
