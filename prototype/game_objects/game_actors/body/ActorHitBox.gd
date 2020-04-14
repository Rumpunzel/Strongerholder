class_name ActorHitBox
extends ObjectHitBox


export(Constants.Actors) var type: int setget , get_type

export var attack_value: float = 2.0


var currently_highlighting: ObjectHitBox = null



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
