tool
extends GameActor
class_name Player

func is_class(class_type): return class_type == "Player" or .is_class(class_type)
func get_class(): return "Player"


var interaction_object:Array = [ ]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func interaction_with(object:GameObject) -> Dictionary:
	if object:
		match object.type:
			CityLayout.FOUNDATION:
				interaction_object = [object, "build_into"]
				var bm = RadiantUI.new(["Build", "Inspect", "Destroy"])
				get_viewport().get_camera().add_ui_element(bm)
				bm.connect("button_pressed", self, "interact_with_object")
				
				return { }
			
			_:
				return .interaction_with(object)
	else:
		return { }


func interact_with_object(new_button:String):
	interaction_object[0].call(interaction_object[1], new_button)
