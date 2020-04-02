tool
extends GameActor
class_name NPC

func is_class(type): return type == "NPC" or .is_class(type)
func get_class(): return "NPC"



func _ready():
	set_currently_searching_for(CityLayout.TREE)
