tool
extends GameObject
class_name TreePoint

func is_class(class_type): return class_type == "TreePoint" or .is_class(class_type)
func get_class(): return "TreePoint"


const tree_scene:PackedScene = preload("res://prefabs/things/GameTree/GameTree.tscn")


var type:String = CityLayout.TREE setget set_type, get_type
var game_tree:GameTree = null setget , get_game_tree



func _init(new_ring_vector:RingVector, new_ring_map:RingMap).(new_ring_map):
	set_ring_vector(new_ring_vector)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_tree()
	inventory.append("Wood")
	ring_map.register_thing(CityLayout.TREE, ring_vector, self)



func entered(body):
	var object = body.get_parent()
	
	if object is GameActor:
		object.add_focus_target(self)
		connect("died", object, "erase_focus_target", [self])
		
		if object is Player:
			object.object_of_interest = self
			set_highlighted(true)

func exited(body):
	var object = body.get_parent()
	
	if object is GameActor:
		if object.focus_targets.has(self):
			object.erase_focus_target(self)
			disconnect("died", object, "erase_focus_target")
		
		if object is Player:
			if object.object_of_interest == self:
				object.object_of_interest = null
			
			set_highlighted(false)


func handle_highlighted():
	if game_tree:
		pass


func interact(sender:GameObject) -> bool:
	if game_tree:
		return game_tree.interact(sender)
	
	return false and .interact(sender)


func die(sender:GameObject):
	if sender is GameActor and sender.object_of_interest == self:
		sender.set_object_of_interest(null)
	
	sender.give(inventory, self)
	
	if game_tree:
		game_tree.queue_free()
		game_tree = null
		
		ring_map.unregister_thing(CityLayout.TREE, ring_vector, self)
		
		.die(sender)




func set_type(new_type:String):
	type = new_type


func set_tree():
	if game_tree:
		remove_child(game_tree)
		game_tree.queue_free()
		game_tree = null
	
	game_tree = tree_scene.instance()
	game_tree.ring_vector = ring_vector
	
	game_tree.transform.origin = Vector3(0, CityLayout.get_height_minimum(ring_vector.ring), ring_vector.radius)
	
	add_child(game_tree)
	
	name = "[tree:(%s, %s)]" % [ring_vector.radius, ring_vector.rotation]


func set_ring_vector(new_vector:RingVector):
	.set_ring_vector(new_vector)
	rotation.y = ring_vector.rotation
	
	if game_tree:
		game_tree.ring_vector = new_vector
	
	name = "[tree:(%s, %s)]" % [ring_vector.radius, ring_vector.rotation]



func get_type() -> String:
	return type


func get_game_tree() -> GameTree:
	return game_tree
