extends CanvasLayer


export(PackedScene) var build_menu


var current_menu:GUIMenu = null
var focus_target = null



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _unhandled_input(event):
	if event.is_action_released("ui_cancel"):
		hide(focus_target)
		get_tree().set_input_as_handled()


func show_build_menu(fundament:BuildingFundament):
	if not fundament == focus_target:
		hide(focus_target)
		
		focus_target = fundament
		
		current_menu = build_menu.instance()
		add_child(current_menu)


func hide(trigger):
	if current_menu and trigger == focus_target:
		current_menu.hide()
		current_menu = null
		focus_target = null
