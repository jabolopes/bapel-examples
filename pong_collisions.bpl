implements pong

imports {
  sdl
}

// Returns true if the line segment (a, b) crosses the infinite
// horizontal line that passes through the `y` coordinate.
fn lineSegmentCrossesHLine(a: sdl.FPoint, b: sdl.FPoint, y: f32) -> bool {
  (a->y > y && b->y < y) || (a->y < y && b->y > y)
}

// Returns true if the line segment (a, b) crosses the infinite
// horizontal line that passes through the `x` coordinate.
fn lineSegmentCrossesVLine(a: sdl.FPoint, b: sdl.FPoint, x: f32) -> bool {
  (a->x > x && b->x < x) || (a->x < x && b->x > x)
}

// See https://bryceboe.com/2006/10/23/line-segment-intersection-algorithm/
fn ccw(a: sdl.FPoint, b: sdl.FPoint, c: sdl.FPoint) -> bool {
  (c->y-a->y) * (b->x-a->x) > (b->y-a->y) * (c->x-a->x)
}

// Returns true if the line segment (a1, b1) crosses the line segment (a2, b2).
//
// See https://bryceboe.com/2006/10/23/line-segment-intersection-algorithm/
fn lineSegmentCrossesSegment(a1: sdl.FPoint, b1: sdl.FPoint, a2: sdl.FPoint, b2: sdl.FPoint) -> bool {
  ccw (a1, a2, b2) != ccw (b1, a2, b2) && ccw (a1, b1, a2) != ccw (a1, b1, b2)
}
