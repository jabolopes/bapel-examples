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

pub fn clamp(v: f32, a: f32, b: f32) -> f32 {
  if v < a {
    return a
  }
  if v > b {
    return b
  }
  v
}

pub fn emptyFRect() -> sdl::FRect {
  struct{x = 0, y = 0, w = 0, h = 0}
}

pub fn centerFRect(rect: sdl::FRect) -> sdl::FPoint {
  struct{x = rect.x + rect.w/2, y = rect.y + rect.h/2}
}

pub fn magnitude(v: sdl::FPoint) -> f32 {
  core::squareRoot (v.x * v.x + v.y * v.y)
}

pub fn normalize(v: sdl::FPoint) -> sdl::FPoint {
  let m: f32 = magnitude v
  if m == 0 {
    return struct{x = 0, y = 0}
  }
  struct{x = v.x / m, y = v.y / m}
}

pub fn subFPoints(v1: sdl::FPoint, v2: sdl::FPoint) -> sdl::FPoint {
  struct{x = v1.x - v2.x, y = v1.y - v2.y}
}

pub fn dotProduct(v1: sdl::FPoint, v2: sdl::FPoint) -> f32 {
  (v1.x * v2.x) + (v1.y * v2.y)
}
