implements pong

imports {
  bapel.core
  sdl
}

// Returns true if the line segment (a, b) crosses the infinite
// horizontal line that passes through the `y` coordinate.
fn lineSegmentCrossesHLine(a: sdl::FPoint, b: sdl::FPoint, y: f32) -> bool {
  (a.y >= y && b.y < y) || (a.y <= y && b.y > y)
}

// Returns true if the line segment (a, b) crosses the infinite
// horizontal line that passes through the `x` coordinate.
fn lineSegmentCrossesVLine(a: sdl::FPoint, b: sdl::FPoint, x: f32) -> bool {
  (a.x >= x && b.x < x) || (a.x <= x && b.x > x)
}

fn linesCross(a_a: sdl::FPoint, a_b: sdl::FPoint, b_a: sdl::FPoint, b_b: sdl::FPoint) -> (sdl::FPoint, bool) {
  let x1: f32 = a_a.x
  let y1: f32 = a_a.y
  let x2: f32 = a_b.x
  let y2: f32 = a_b.y

  let x3: f32 = b_a.x
  let y3: f32 = b_a.y
  let x4: f32 = b_b.x
  let y4: f32 = b_b.y

  let denominator: f32 = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
  if denominator == 0 {
    let intersection: sdl::FPoint = struct{x = 0, y = 0}
    return (intersection, false)
  }

  let xNominator: f32 = (x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)
  let yNominator: f32 = (x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)

  let px: f32 = xNominator / denominator
  let py: f32 = yNominator / denominator

  let intersection: sdl::FPoint = struct{x = px, y = py}
  (intersection, true)
}

fn getLineSegmentLeft(rect: sdl::FRect) -> (sdl::FPoint, sdl::FPoint) {
  let c1: sdl::FPoint = struct{x = rect.x, y = rect.y}
  let c2: sdl::FPoint = set c1 {y = c1.y + rect.h}
  (c1, c2)
}

fn getLineSegmentBottom(rect: sdl::FRect) -> (sdl::FPoint, sdl::FPoint) {
  let c1: sdl::FPoint = struct{x = rect.x, y = rect.y + rect.h}
  let c2: sdl::FPoint = set c1 {x = c1.x + rect.w}
  (c1, c2)
}

fn getLineSegmentRight(rect: sdl::FRect) -> (sdl::FPoint, sdl::FPoint) {
  let c1: sdl::FPoint = struct{x = rect.x + rect.w, y = rect.y + rect.h}
  let c2: sdl::FPoint = set c1 {y = rect.y}
  (c1, c2)
}

fn getLineSegmentTop(rect: sdl::FRect) -> (sdl::FPoint, sdl::FPoint) {
  let c1: sdl::FPoint = struct{x = rect.x + rect.w, y = rect.y}
  let c2: sdl::FPoint = set c1 {x = rect.x}
  (c1, c2)
}

fn lineSegmentCrossesRect(a: sdl::FPoint, b: sdl::FPoint, rect: sdl::FRect) -> (sdl::FPoint, sdl::FPoint, bool) {
  let intersection: sdl::FPoint = struct{x = 0, y = 0}
  let bounce: sdl::FPoint = struct{x = 0, y = 0}
  let ok: bool = false

  if sdl::PointInRectFloat(a, rect) {
    return (intersection, bounce, false)
  }
  if !sdl::PointInRectFloat(b, rect) {
    return (intersection, bounce, false)
  }

  if lineSegmentCrossesVLine (a, b, rect.x) {
    let left: (sdl::FPoint, sdl::FPoint) = getLineSegmentLeft rect
    (intersection, ok) <- linesCross (a, b, left.0, left.1)
    if ok {
      let bounce: sdl::FPoint = subFPoints (intersection, centerFRect rect)
      return (intersection, bounce, true)
    }
  }

  if lineSegmentCrossesHLine (a, b, rect.y + rect.h) {
    let bottom: (sdl::FPoint, sdl::FPoint) = getLineSegmentBottom rect
    (intersection, ok) <- linesCross (a, b, bottom.0, bottom.1)
    if ok {
      let bounce: sdl::FPoint = subFPoints (intersection, centerFRect rect)
      return (intersection, bounce, true)
    }
  }

  if lineSegmentCrossesVLine (a, b, rect.x + rect.w) {
    let right: (sdl::FPoint, sdl::FPoint) = getLineSegmentRight rect
    (intersection, ok) <- linesCross (a, b, right.0, right.1)
    if ok {
      let bounce: sdl::FPoint = subFPoints (intersection, centerFRect rect)
      return (intersection, bounce, true)
    }
  }

  if lineSegmentCrossesHLine (a, b, rect.y) {
    let top: (sdl::FPoint, sdl::FPoint) = getLineSegmentTop rect
    (intersection, ok) <- linesCross (a, b, top.0, top.1)
    if ok {
      let bounce: sdl::FPoint = subFPoints (intersection, centerFRect rect)
      return (intersection, bounce, true)
    }
  }

  (intersection, bounce, false)
}
