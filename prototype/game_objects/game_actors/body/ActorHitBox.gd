class_name ActorHitBox
extends ObjectHitBox


export(NodePath) var puppet_master_node

export(Constants.Actors) var type: int setget , get_type


var currently_highlighting: ObjectHitBox = null



func parse_entering_hit_box(new_hit_box: ObjectHitBox):
	.parse_entering_hit_box(new_hit_box)
	highlight_object()


func parse_exiting_hit_box(new_hit_box: ObjectHitBox):
	.parse_exiting_hit_box(new_hit_box)
	highlight_object()



func highlight_object():
	if get_node(puppet_master_node).is_player_controlled():
		if currently_highlighting:
			currently_highlighting.set_highlighted(false)
		
		if not overlapping_hit_boxes.empty():
			currently_highlighting = overlapping_hit_boxes.front()
			currently_highlighting.set_highlighted(true)
		else:
			currently_highlighting = null


func get_type() -> int:
	return type
