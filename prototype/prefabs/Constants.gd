class_name Constants
extends Resource


const NONE: int = 0
const BUILDINGS: int = 64
const ACTORS: int = 256
const RESOURCES: int = 512
const THINGS: int = 1024


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
	
	WOOD = RESOURCES,
	STONE,
	
	TREE = THINGS,
}



static func object_type(enum_index: int) -> int:
	if enum_index < BUILDINGS:
		return NONE
	elif enum_index < ACTORS:
		return BUILDINGS
	elif enum_index < RESOURCES:
		return ACTORS
	elif enum_index < THINGS:
		return RESOURCES
	else:
		return THINGS


static func enum_name(enumerator, index: int) -> String:
	return enumerator.keys()[enumerator.values().find(index)]
