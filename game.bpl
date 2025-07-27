module game

imports {
  bapel.core
}

impls {
  "game_game.ccm"
  "game_ecs.ccm"
  "game_prefabs.bpl"
  "game_input.bpl"
  "game_material.ccm"
  "game_render.ccm"
  "game_options.bpl"
  "game_impl.ccm"
}

flags {
  "-ISDL/include"
  "-Wl,-rpath,SDL/build"
  "-LSDL/build"
  "-lSDL3"

  "-DENTT_NO_ETO"
  "-Ientt/single_include"
}
