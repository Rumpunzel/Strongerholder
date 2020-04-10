class_name Constants
extends Resource


const NONE: int = 0
const BUILDINGS: int = 64
const ACTORS: int = 256
const THINGS: int = 512
const RESOURCES: int = 1024
const REQUEST: int = 2048


enum Objects {
	NOTHING = NONE,
	EVERYTHING,
	EMPTY,
	
	BASE = BUILDINGS,
	BRIDGE,
	FOUNDATION,
	STOCKPILE,
	WOODCUTTERS_HUT,
	
	PLAYER = ACTORS,
	WOODSMAN,
	CARPENTER,
	
	WOOD = RESOURCES,
	WOOD_PLANKS,
	STONE,
	
	TREE = THINGS,
}



static func object_type(enum_index: int) -> int:
	if enum_index < BUILDINGS:
		return NONE
	elif enum_index < ACTORS:
		return BUILDINGS
	elif enum_index < THINGS:
		return ACTORS
	elif enum_index < RESOURCES:
		return THINGS
	elif enum_index < REQUEST:
		return RESOURCES
	else:
		return REQUEST


static func enum_name(enumerator, index: int) -> String:
	return enumerator.keys()[enumerator.values().find(index)]
