class_name ActorHitBox, "res://assets/icons/game_actors/actor_hit_box.svg"
extends ObjectHitBox


export(Constants.Actors) var type: int

export var attack_value: float = 2.0

export(NodePath) var _animation_player_node
export(NodePath) var _animation_tree_node


var currently_highlighting: ObjectHitBox = null
var placing_this_building = null setget set_placing_this_building


onready var _animation_player: AnimationPlayer = get_node(_animation_player_node)
onready var _animation_tree: AnimationStateMachine = get_node(_animation_tree_node)




func initialize():
	.initialize()
	owner.connect("entered_segment", self, "_move_building")




func attack(other_hit_box: ObjectHitBox):
	_animation_tree.travel("attack")
	
	yield(_animation_player, "attacked")
	
	other_hit_box.damage(attack_value, self)


func offer_item(item: int, receiver: ObjectHitBox):
	_animation_tree.travel("give")
	
	yield(_animation_player, "given")
	
	.offer_item(item, receiver)


func request_item(item: int, sender: ObjectHitBox):
	_animation_tree.travel("give")
	
	yield(_animation_player, "given")
	
	.request_item(item, sender)


func open_menu(new_menu: RadiantUI):
	if not placing_this_building:
		_animation_tree.travel("idle")
		
		_animation_tree.can_act = false
		new_menu.connect("closed", _animation_tree, "set_can_act", [true])
		
		get_viewport().get_camera().add_ui_element(new_menu)
	elif not placing_this_building.is_blocked():
		_animation_tree.travel("give")
		
		yield(_animation_player, "given")
		
		if placing_this_building:
			placing_this_building.activate_structure()
			placing_this_building = null
	else:
		_animation_tree.travel("give")



func parse_entering_hit_box(new_hit_box: ObjectHitBox) -> bool:
	if .parse_entering_hit_box(new_hit_box):
		highlight_object()
		
		return true
	else:
		return false


func parse_exiting_hit_box(new_hit_box: ObjectHitBox):
	.parse_exiting_hit_box(new_hit_box)
	highlight_object()



func highlight_object():
	if type == Constants.Actors.PLAYER:
		if currently_highlighting:
			currently_highlighting.set_highlighted(false)
		
		if not _overlapping_hit_boxes.empty():
			currently_highlighting = _overlapping_hit_boxes.front()
			currently_highlighting.set_highlighted(true)
		else:
			currently_highlighting = null




func _move_building(new_vector: RingVector):
	if placing_this_building:
		placing_this_building.ring_vector = RingVector.new(new_vector.ring, new_vector.segment, true)




func set_placing_this_building(new_object):
	placing_this_building = new_object
	get_tree().current_scene.get_node("city_structures").add_child(placing_this_building)
	_move_building(owner.ring_vector)
