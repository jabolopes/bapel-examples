implements game

imports {
  bapel.core
	bapel.stl
  sdl
}

type PrefabID = struct{
  id i64,
}

type Tile = struct{
  code String,
}

type Info = struct{
  id String,
  cat String,
  sub String,
}

fn emptyInfo() -> Info {
  struct{id = "", cat = "", sub = ""}
}

type CardImporter = struct{
  avatarTexName String,
  color String,
  text String,
}

type CharacterDirImporter = struct{
  dir String,
}

type CharacterDir = struct{
	dir sdl::Point,
}

type Chest = struct{
  id i64,
}

type InventoryImporter = struct{
	items String,
}

type Potion = struct{
	hp i64,
}

type Sector = struct{
	clip i64,
	gen i64,
	base String,
	layers String,
	bgTexName String,
	floorTexName String,
}

// All entities managed by a `liveSector` automatically have a
// `SectorPos` will stores their position in the sector.
type SectorPos = struct{
	pos sdl::Point,
}

type Specs = struct{
	// Base armor at level 1.
	ba i64,
	// Per-level armor percent increase.
	la f32,
	// Base damage at level 1.
	bd i64,
	// Per-level damage percent increase.
	ld f32,
	// Base health at level 1.
	bh i64,
	// Per-level health percent increase.
	lh f32,
	// Base magic at level 1.
	bm i64,
	// Per-level magic percent increase.
	lm f32,
	// Base gold at level 1.
	bg i64,
	// Per-level gold.
	lg f32,
}
