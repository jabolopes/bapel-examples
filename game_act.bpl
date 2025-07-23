implements game

imports {
  bapel.core
  sdl
}

type ActType = variant{
  otherAct (),
  attackAct (),
  doAct (),
  specialAct (),
  useAct (),
}

// IDs are -1 if they are not defined.
type Act = struct{
	typ ActType,

	// Entity that produces the act, e.g., player.
	sourceID Entity,
	// Info of target.
	sourceInfo Info,
	// Position of `sourceID`.
	sourcePos sdl.Point,
	// Direction of `sourceID` (if any).
	sourceDir sdl.Point,
	// World position of `sourceID`
	sourceWorldPos sdl.Point,
	// Direction `sourceID` wants to move in (if any).
	sourceMoveDir sdl.Point,

	// Entity that receives the act, e.g., character, chest, wall, etc.
	targetID Entity,
	// Info of target.
	targetInfo Info,
	// Position of target.
	targetPos sdl.Point,
	// Direction of target (if any).
	targetDir sdl.Point,

	// Optional item being used by source on target, e.g., key, skill, etc.
	itemID Entity,
	// Info of item.
	itemInfo Info,
	// Position of item (if any).
	itemPos sdl.Point,
}

fn hasTarget(actref: ref.Ref Act) -> bool {
  let act: Act = ref.get [Act] actref
  ecs.is_valid act->targetID
}

fn hasItem(actref: ref.Ref Act) -> bool {
  let act: Act = ref.get [Act] actref
  ecs.is_valid act->itemID
}

// TODO: Finish game.mech.sector.
fn fillSource(actref: ref.Ref Act, id: Entity) -> () {
  let act: Act = ref.get [Act] actref

	act <- set act {sourceID = id}
	if ecs.is_valid id {
    act <- set act {
		  sourceInfo = emptyInfo(),
		  sourcePos = struct{x = 0, y = 0},
		  sourceDir = struct{x = 0, y = 0},
		  sourceWorldPos = struct{x = 0, y = 0},
    }
		return ()
	}

  let info: std.optional Info = ecs.get [Info] id
  if has_value [Info] info {
    act <- set act {sourceInfo = get_value [Info] info}
  }

  let sourcePos: std.optional SectorPos = ecs.get [SectorPos] id
  if has_value [SectorPos] sourcePos {
    act <- set act {sourcePos = (get_value [SectorPos] sourcePos)->pos}
  }

  let sourceDir: std.optional CharacterDir = ecs.get [CharacterDir] id
  if has_value [CharacterDir] sourceDir {
    act <- set act {sourceDir = (get_value [CharacterDir] sourceDir)->dir}
  }

  ref.set [Act] (actref, act)

  ()
}
