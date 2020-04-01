tool
extends GameObject
class_name TreePoint

func is_class(type): return type == "TreePoint" or .is_class(type)
func get_class(): return "TreePoint"


const tree_scene:PackedScene = preload("res://prefabs/things/GameTree/GameTree.tscn")


var game_tree:GameTree = null setget , get_game_tree

var gui



func _init(new_ring_vector:RingVector, new_ring_map:RingMap, new_gui).(new_ring_map):
	#tree_offset += Vector3((randf() * 0.25 + (0.2 if randi() % 2 == 0 else -0.4)) * CityLayout.SEGMENT_WIDTH, 0, randf() * 2)
	set_ring_vector(new_ring_vector)
	gui = new_gui


# Called when the node enters the scene tree for the first time.
func _ready():
	set_tree()
	
	ring_map.register_thing(CityLayout.TREE, ring_vector, self)



func entered(body):
	var object = body.get_parent()
	
	if object is GameActor:
		object.focus_target = self
		
		if object is Player:
			set_highlighted(true)

func exited(body):
	var object = body.get_parent()
	
	if object is GameActor:
		if object.focus_target == self:
			object.focus_target = null
		
		if object is Player:
			set_highlighted(false)
			
			gui.hide(self)



func handle_highlighted():
	if game_tree:
		pass


func interact(sender:GameObject, action:String) -> bool:
	print("%s %s with %s." % [sender.name, "interacted" if action == "" else action, name])
	
	if game_tree:
		return game_tree.interact(sender, action)
	
	return false




func set_tree():
	if game_tree:
		remove_child(game_tree)
		game_tree.queue_free()
		game_tree = null
	
	game_tree = tree_scene.instance()
	game_tree.ring_vector = ring_vector
	game_tree.gui = gui
	
	set_world_position(Vector3(0, CityLayout.get_height_minimum(ring_vector.ring), ring_vector.radius))
	
	add_child(game_tree)
	
	name = "[tree][%s, %s]" % [ring_vector.radius, ring_vector.rotation]


func set_ring_vector(new_vector:RingVector):
	.set_ring_vector(new_vector)
	rotation.y = ring_vector.rotation
	
	if game_tree:
		game_tree.ring_vector = new_vector
	
	name = "[tree][%s, %s]" % [ring_vector.radius, ring_vector.rotation]


func set_world_position(new_position:Vector3):
	if game_tree:
		game_tree.transform.origin = new_position
		#ring_vector.rotation = Vector2(game_tree.transform.origin.x, game_tree.transform.origin.z).angle_to(Vector2.DOWN)
	else:
		.set_world_position(new_position)



func get_game_tree() -> GameTree:
	return game_tree


func get_world_position() -> Vector3:
	if game_tree:
		return game_tree.global_transform.origin
	else:
		return .get_world_position()
