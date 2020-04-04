tool
extends GameActor
class_name Player

func is_class(class_type): return class_type == "Player" or .is_class(class_type)
func get_class(): return "Player"




# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func interaction_with(object:GameObject) -> Dictionary:
	if object:
		match object.type:
			CityLayout.FOUNDATION:
				var build_menu = RadiantUI.new(["Build", "Inspect", "Destroy"], object, "build_into")
				get_viewport().get_camera().add_ui_element(build_menu)
			
			_:
				return .interaction_with(object)
	
	return { }
