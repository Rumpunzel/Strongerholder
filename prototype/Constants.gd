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
	BASE,
	BRIDGE,
	FOUNDATION,
	STOCKPILE,
	WOODCUTTERS_HUT,
	
	TREE = 512,
}



static func is_actor(index) -> bool:
	return Actors.values().has(index)

static func is_structure(index) -> bool:
	return index > Structures.EVERYTHING and index < Structures.TREE and Structures.values().has(index)

static func is_thing(index) -> bool:
	return index >= Structures.TREE and Structures.values().has(index)


static func enum_name(enumerator, index: int) -> String:
	return enumerator.keys()[enumerator.values().find(index)]
