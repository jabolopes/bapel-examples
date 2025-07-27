module sdl

imports {
  bapel.core
}

impls {
  "sdl_impl.ccm"
}

flags {
  "-lSDL3"
}

export fn clamp(v: f32, a: f32, b: f32) -> f32 {
  if v < a {
    return a
  }
  if v > b {
    return b
  }
  v
}

export fn emptyFRect() -> sdl.FRect {
  struct{x = 0, y = 0, w = 0, h = 0}
}

export fn centerFRect(rect: sdl.FRect) -> sdl.FPoint {
  struct{x = rect->x + rect->w/2, y = rect->y + rect->h/2}
}

export fn magnitude(v: sdl.FPoint) -> f32 {
  core.squareRoot (v->x * v->x + v->y * v->y)
}

export fn normalize(v: sdl.FPoint) -> sdl.FPoint {
  let m: f32 = magnitude v
  if m == 0 {
    return struct{x = 0, y = 0}
  }
  struct{x = v->x / m, y = v->y / m}
}

export fn subFPoints(v1: sdl.FPoint, v2: sdl.FPoint) -> sdl.FPoint {
  struct{x = v1->x - v2->x, y = v1->y - v2->y}
}

export fn dotProduct(v1: sdl.FPoint, v2: sdl.FPoint) -> f32 {
  (v1->x * v2->x) + (v1->y * v2->y)
}
