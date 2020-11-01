class_name Constants
extends Resource


enum {
	NOTHING = 0,
	EVERYTHING,
	EMPTY,
}

enum Actors {
	NOTHING = 0,
	EVERYTHING = 64,
	PLAYER,
	WOODSMAN,
	CARPENTER,
}

enum Structures {
	NOTHING = 0,
	EVERYTHING = 256,
	STOCKPILE,
	WOODCUTTERS_HUT,
	LUMBER_MILL,
	MARKET,
	TENT,
	
	TREE = 512,
}

enum Resources {
	NOTHING = 1024,
	WOOD_LOG,
	LUMBER,
	WOOD_PLANKS,
	STONE,
	SPYGLASS = 2048,
	AXE,
	SAW,
}


const REQUEST = "REQUEST_"



static func is_actor(index) -> bool:
	return Actors.values().has(index)

static func is_structure(index) -> bool:
	return index is int and index > Structures.EVERYTHING and index < Structures.TREE and Structures.values().has(index)

static func is_thing(index) -> bool:
	return index is int and index >= Structures.TREE and Structures.values().has(index)

static func is_resource(index) -> bool:
	return Resources.values().has(index)

static func is_craft_tool(index) -> bool:
	return Resources.values().has(index) and index >= Resources.SPYGLASS


static func enum_name(enumerator, index: int) -> String:
	return enumerator.keys()[enumerator.values().find(index)]
