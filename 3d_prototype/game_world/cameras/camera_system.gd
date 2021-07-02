class_name CameraSystem
extends Node


export(NodePath) var _main_camera_node

var current_camera: GameCamera setget set_current_camera


func _enter_tree() -> void:
	var error := Events.connect("player_instantiated", self, "_on_player_instantiated")
	assert(error == OK)
	
	ServiceLocator.register_service(self)
	set_current_camera(get_node(_main_camera_node) as GameCamera)

func _exit_tree() -> void:
	Events.disconnect("player_instantiated", self, "_on_player_instantiated")


static func get_service_class() -> String:
	return "CameraSystem"


func get_class() -> String:
	return get_service_class()

func frame_node(node: Spatial) -> void:
	assert(node)
	current_camera.follow_node = node


func _on_player_instantiated(player_node: Spatial) -> void:
	assert(player_node)
	frame_node(player_node)


func set_current_camera(new_camera: GameCamera) -> void:
	assert(new_camera)
	
	var follow_node: Spatial = null
	
	if current_camera:
		follow_node = current_camera.follow_node
		current_camera.current = false
	
	current_camera = new_camera
	current_camera.current = true
	
	Events.emit_signal("camera_changed", current_camera)
	
	if follow_node:
		current_camera.follow_node = follow_node
