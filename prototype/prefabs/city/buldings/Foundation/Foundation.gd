tool
extends CityObject
class_name Foundation

func is_class(type): return type == "Foundation" or .is_class(type)
func get_class(): return "Foundation"



func handle_highlighted(new_material):
	get_node("block").material_override = new_material


func interact(_sender:GameObject, _action:String) -> bool:
	gui.show_build_menu(game_object)
	return true
