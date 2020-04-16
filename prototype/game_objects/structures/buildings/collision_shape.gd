extends CollisionShape



# Called when the node enters the scene tree for the first time.
func _ready():
	disabled = true
	owner.connect("activate", self, "set_disabled", [false])
