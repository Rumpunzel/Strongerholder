extends CityObject
class_name GameTree

func is_class(class_type): return class_type == "GameTree" or .is_class(class_type)
func get_class(): return "GameTree"


func handle_highlighted(_new_material:Material):
	pass

func interact(_sender:GameObject) -> bool:
	return true
