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

export fn emptyFRect() -> sdl.FRect {
  struct{x = 0, y = 0, w = 0, h = 0}
}

export fn centerFRect(rect: sdl.FRect) -> sdl.FPoint {
  struct{x = rect->x + rect->w/2, y = rect->y + rect->h/2}
}

export fn subFPoints(v1: sdl.FPoint, v2: sdl.FPoint) -> sdl.FPoint {
  struct{x = v1->x - v2->x, y = v1->y - v2->y}
}

export fn dotProduct(v1: sdl.FPoint, v2: sdl.FPoint) -> f32 {
  (v1->x * v2->x) + (v1->y * v2->y)
}

// Assumes counter-clockwise winding. For example, a line segment (0,
// 10) will have a perpendicular vector (-10, 0). If a rect is defined
// by line segments in counter-clockwise winding, such as, ((0, 0),
// (0, 10)), etc, this will result in outward facing perpendicular
// vectors.
export fn perpendicularFPoint(v: sdl.FPoint) -> sdl.FPoint {
  struct{x = -v->y, y = v->x}
}
