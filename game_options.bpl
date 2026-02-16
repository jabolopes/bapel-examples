implements game

imports {
  sdl
}

pub type GameOptions = struct{
  windowSize sdl::Point,
  keyboardHandler sdl::KeyboardEvent -> (),
  updateHandler () -> (),
}
