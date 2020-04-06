extends GameActor
class_name Player

func is_class(class_type): return class_type == "Player" or .is_class(class_type)
func get_class(): return "Player"


var last_menu setget set_last_menu



func _ready():
	connect("new_interest", self, "close_last_menu")




func interaction_with(object:GameObject) -> Dictionary:
	if object:
		match object.type:
			CityLayout.FOUNDATION:
				if not last_menu:
					last_menu = RadiantUI.new(["Build", "Inspect", "Destroy"], object, "build_into")
					get_viewport().get_camera().add_ui_element(last_menu)
					last_menu.connect("closed", self, "set_last_menu", [null])
			
			_:
				return .interaction_with(object)
	
	return { }


func close_last_menu(_whatever = null):
	if last_menu:
		last_menu.close()



func set_last_menu(new_menu):
	last_menu = new_menu
