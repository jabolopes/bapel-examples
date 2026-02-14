implements game

imports {
  sdl
}

export type GameOptions = struct{
  windowSize sdl::Point,
  keyboardHandler sdl::KeyboardEvent -> (),
  updateHandler () -> (),
}
