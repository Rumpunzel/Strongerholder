tool
extends GameActor
class_name NPC

func is_class(class_type): return class_type == "NPC" or .is_class(class_type)
func get_class(): return "NPC"



func _process(_delta):
	if can_act:
		if inventory.empty():
			set_currently_searching_for(CityLayout.TREE)
		else:
			set_currently_searching_for(CityLayout.STOCKPILE)
