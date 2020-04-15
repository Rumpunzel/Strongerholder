class_name ActorHitBox
extends ObjectHitBox


export(Constants.Actors) var type: int setget , get_type

export var attack_value: float = 2.0

export(NodePath) var animation_player_node
export(NodePath) var animation_tree_node


var currently_highlighting: ObjectHitBox = null


onready var animation_player: AnimationPlayer = get_node(animation_player_node)
onready var animation_tree: AnimationStateMachine = get_node(animation_tree_node)



func attack(other_hit_box: ObjectHitBox):
	animation_tree.travel("attack")
	
	yield(animation_player, "attacked")
	
	other_hit_box.damage(attack_value, self)


func offer_item(item, receiver):
	animation_tree.travel("give")
	
	yield(animation_player, "given")
	
	inventory.send_item(item, receiver)


func request_item(item, sender):
	animation_tree.travel("give")
	
	yield(animation_player, "given")
	
	inventory.receive_item(item, sender)


func open_menu(new_menu: RadiantUI):
	animation_tree.travel("give")
	animation_tree.can_act = false
	new_menu.connect("closed", animation_tree, "set_can_act", [true])
	
	yield(animation_player, "given")
	
	get_viewport().get_camera().add_ui_element(new_menu)



func parse_entering_hit_box(new_hit_box: ObjectHitBox):
	.parse_entering_hit_box(new_hit_box)
	highlight_object()


func parse_exiting_hit_box(new_hit_box: ObjectHitBox):
	.parse_exiting_hit_box(new_hit_box)
	highlight_object()



func highlight_object():
	if type == Constants.Actors.PLAYER:
		if currently_highlighting:
			currently_highlighting.set_highlighted(false)
		
		if not overlapping_hit_boxes.empty():
			currently_highlighting = overlapping_hit_boxes.front()
			currently_highlighting.set_highlighted(true)
		else:
			currently_highlighting = null


func get_type() -> int:
	return type
