module sdl

impls {
  "sdl_impl.ccm"
}

flags {
  "-ISDL/include"
  "-Wl,-rpath,SDL/build"
  "-LSDL/build"
  "-lSDL3"
}
