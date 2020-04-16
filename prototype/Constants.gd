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
	EVERYTHING,
	PLAYER,
	WOODSMAN,
	CARPENTER,
}

enum Structures {
	NOTHING = 256,
	EVERYTHING,
	BASE,
	BRIDGE,
	FOUNDATION,
	STOCKPILE,
	WOODCUTTERS_HUT,
	TREE,
}

enum Resources {
	NOTHING = 1024,
	EVERYTHING,
	WOOD,
	WOOD_PLANKS,
	STONE,
}



static func is_actor(index) -> bool:
	return Actors.values().has(index)

static func is_structure(index) -> bool:
	return Structures.values().has(index)

static func is_resource(index) -> bool:
	return Resources.values().has(index)

static func is_request(index) -> bool:
	return index is int and index >= REQUEST


static func enum_name(enumerator, index: int) -> String:
	return enumerator.keys()[enumerator.values().find(index)]
