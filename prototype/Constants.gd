class_name Constants
extends Resource


enum {
	NOTHING = 0,
	EVERYTHING,
	EMPTY,
	REQUEST = 2048,
}

enum Actors {
	NOTHING = 64,
	PLAYER,
	WOODSMAN,
	CARPENTER,
}

enum Structures {
	NOTHING = 256,
	BASE,
	BRIDGE,
	FOUNDATION,
	STOCKPILE,
	WOODCUTTERS_HUT,
	TREE,
}

enum Resources {
	NOTHING = 1024,
	WOOD,
	WOOD_PLANKS,
	STONE,
}



static func is_actor(index: int) -> bool:
	return Actors.has(index)

static func is_structure(index: int) -> bool:
	return Structures.has(index)

static func is_resource(index: int) -> bool:
	return Resources.has(index)

static func is_request(index: int) -> bool:
	return index >= REQUEST


static func enum_name(enumerator, index: int) -> String:
	return enumerator.keys()[enumerator.values().find(index)]
