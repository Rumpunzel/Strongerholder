tool
extends CityObject
class_name GameTree

func is_class(type): return type == "GameTree" or .is_class(type)
func get_class(): return "GameTree"


func handle_highlighted(_new_material:Material):
	pass


func interact(_sender:GameObject, _action:String) -> bool:
	return true
