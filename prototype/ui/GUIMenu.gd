extends Control
class_name GUIMenu


onready var gui = get_parent()

onready var tween:Tween = Tween.new()


var focus_target = null setget set_focus_target, get_focus_target



# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0
	
	add_child(tween)
	
	fade_in()



func hide():
	fade_out()


func fade_in():
	tween.interpolate_property(self, "rect_position:y", 256, 0, 0.3, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.interpolate_property(self, "modulate:a", 0, 1, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func fade_out():
	tween.interpolate_property(self, "rect_position:y", 0, 256, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "modulate:a", 1, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	get_parent().remove_child(self)
	queue_free()




func set_focus_target(new_target):
	focus_target = new_target



func get_focus_target():
	return focus_target
