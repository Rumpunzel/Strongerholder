class_name BuildMenu
extends Control


onready var _popup: Popup = $popup



func place_building(structure: CityStructure):
	pass



func _open_build_menu():
	_popup.show()


func _close():
	_popup.hide()
