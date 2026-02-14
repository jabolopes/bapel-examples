implements pong

imports {
  game
  sdl
}

type PlayerInput = struct{
  up bool,
  down bool,
}

fn initPlayerInput() -> () {
  ecs::init [PlayerInput] (ecs::add (), struct{up = false, down = false})
  ()
}

fn getPlayerInput () -> PlayerInput {
  let playerInput: std::optional (Entity, PlayerInput) = ecs::getAny [PlayerInput] ()
  if !has_value [(Entity, PlayerInput)] playerInput {
    return struct{up = false, down = false}
  }

  (get_value [(Entity, PlayerInput)] playerInput)->1
}

fn updatePlayerInput(event: sdl::KeyboardEvent) -> () {
  if event->repeat {
    return ()
  }

  let input: PlayerInput = getPlayerInput ()

  if event->key == sdl::keyUp {
    input <- set input {up = event->down}
  } else {
    if event->key == sdl::keyDown {
      input <- set input {down = event->down}
    }
  }

  ecs::setAny [PlayerInput] input
}
