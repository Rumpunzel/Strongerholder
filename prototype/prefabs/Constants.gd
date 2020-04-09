class_name Constants
extends Resource


const ACTORS: int = 64
const BUILDINGS: int = 512
const THINGS: int = 1024

enum Objects {
	NOTHING,
	EVERYTHING,
	EMPTY,
	
	PLAYER = ACTORS,
	WOODSMAN,
	
	BASE = BUILDINGS,
	BRIDGE,
	FOUNDATION,
	STOCKPILE,
	
	TREE = THINGS,
}


static func enum_name(enumerator, index: int) -> String:
	return enumerator.keys()[enumerator.values().find(index)]
