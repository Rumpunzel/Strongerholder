extends CharacterSignals
class_name PlayerSignals


# Called when the node enters the scene tree for the first time.
func _ready():
	character.connect("stopped_jumping", body, "jump")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
