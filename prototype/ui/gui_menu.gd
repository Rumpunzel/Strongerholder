extends Control
class_name GUIMenu


onready var tween:Tween = Tween.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0
	
	add_child(tween)
	
	fade_in()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func hide():
	fade_out()


func fade_in():
	tween.interpolate_property(self, "rect_position:y", 256, 0, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.interpolate_property(self, "modulate:a", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func fade_out():
	tween.interpolate_property(self, "rect_position:y", 0, 256, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN)
	tween.interpolate_property(self, "modulate:a", 1, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	get_parent().remove_child(self)
	queue_free()