extends GUIMenu



# Called when the node enters the scene tree for the first time.
func _ready():
	for tab in $tab_container.get_children():
		for button in tab.get_children():
			button.connect("pressed", self, "build_stockpile")
	
	$tab_container/dummy.get_child(0).grab_focus()



func build_stockpile():
	focus_target.build_into(CityLayout.STOCKPILE)
	
	gui.hide(focus_target)
