class_name WorldScene
extends Navigation


func _enter_tree() -> void:
	var error := Events.gameplay.connect("node_spawned", self, "_on_node_spawned")
	assert(error == OK)

func _exit_tree() -> void:
	Events.gameplay.disconnect("node_spawned", self, "_on_node_spawned")


func _ready() -> void:
	Events.gameplay.emit_signal("scene_loaded")



func _on_node_spawned(node: Spatial, position: Vector3, random_rotation: bool) -> void:
	add_child(node)
	node.translation = position
	
	if random_rotation:
		node.rotate_x(randf() * TAU)
		node.rotate_y(randf() * TAU)
		node.rotate_z(randf() * TAU)
