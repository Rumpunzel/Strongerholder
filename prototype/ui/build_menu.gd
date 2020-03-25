extends GUIMenu


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for tab in $panel_container/tab_container.get_children():
		for button in tab.get_children():
			button.connect("pressed", self, "build_stockpile")
	
	$panel_container/tab_container/dummy.get_child(0).grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func build_stockpile():
	var new_stockpile = preload("res://prefabs/city/buldings/stockpile/stockpile.tscn").instance()
	focus_target.build_into(new_stockpile)
	
	GUI.hide(focus_target)
