extends GameActor
class_name Player

func is_class(class_type): return class_type == "Player" or .is_class(class_type)
func get_class(): return "Player"




func interaction_with(object:GameObject) -> Dictionary:
	if object:
		match object.type:
			CityLayout.FOUNDATION:
				var build_menu = RadiantUI.new(["Build", "Inspect", "Destroy"], object, "build_into")
				get_viewport().get_camera().add_ui_element(build_menu)
				#connect("new_interest", self, "close_last_menu", [build_menu])
			
			_:
				return .interaction_with(object)
	
	return { }


func close_last_menu(_whatever, last_menu):
	disconnect("new_interest", self, "close_last_menu")
	last_menu.close()
