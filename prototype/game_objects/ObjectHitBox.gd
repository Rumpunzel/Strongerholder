class_name ObjectHitBox
extends Area


signal added_object(game_object)
signal activated
signal died


export(NodePath) var graphics_node


export var hit_points_max: float = 10.0 setget , get_hit_points_max
export var indestructible: bool = false setget , get_indestructible




var active: bool = true setget set_active, is_active
var alive: bool = true setget set_alive, is_alive
var highlighted: bool = false setget set_highlighted, get_highlighted


var overlapping_hit_boxes: Array = [ ]
var inactive_overlapping_hit_boxes: Array = [ ]


onready var hit_points: float = hit_points_max




# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", self, "entered")
	connect("area_exited", self, "exited")



func damage(damage_points: float, sender: ObjectHitBox = null) -> bool:
	hit_points -= damage_points
	
	#print("%s damaged %s for %s damage." % [sender.name, name, damage_points])
	
	if not indestructible and hit_points <= 0:
		die(sender)
		return false
	
	return true


func die(sender: ObjectHitBox):
	set_alive(false)
	
#	if sender:
#		sender.receive_items(inventory, self)
	
	owner.set_process(false)



func entered(new_hit_box: ObjectHitBox):
	if parse_entering_hit_box(new_hit_box):
		emit_signal("added_object", new_hit_box)


func exited(new_hit_box: ObjectHitBox):
	parse_exiting_hit_box(new_hit_box)



func parse_entering_hit_box(new_hit_box: ObjectHitBox):
	if new_hit_box.active and not overlapping_hit_boxes.has(new_hit_box):
		add_hit_box_to_array(new_hit_box, overlapping_hit_boxes)
		new_hit_box.connect("died", self, "parse_exiting_hit_box", [new_hit_box])
	elif not inactive_overlapping_hit_boxes.has(new_hit_box):
		add_hit_box_to_array(new_hit_box, inactive_overlapping_hit_boxes)
		new_hit_box.connect("activated", self, "parse_acitvating_hit_box", [new_hit_box])
		new_hit_box.connect("died", self, "parse_exiting_hit_box", [new_hit_box])


func parse_exiting_hit_box(new_hit_box: ObjectHitBox):
	if overlapping_hit_boxes.has(new_hit_box):
		overlapping_hit_boxes.erase(new_hit_box)
		new_hit_box.disconnect("died", self, "parse_exiting_hit_box")
	elif inactive_overlapping_hit_boxes.has(new_hit_box):
		inactive_overlapping_hit_boxes.erase(new_hit_box)
		new_hit_box.disconnect("activated", self, "parse_acitvating_hit_box")
		new_hit_box.disconnect("died", self, "parse_exiting_hit_box")


func parse_acitvating_hit_box(new_hit_box: ObjectHitBox):
	if inactive_overlapping_hit_boxes.has(new_hit_box):
		inactive_overlapping_hit_boxes.erase(new_hit_box)
		new_hit_box.disconnect("activated", self, "parse_acitvating_hit_box")
		parse_entering_hit_box(new_hit_box)


func add_hit_box_to_array(new_hit_box: ObjectHitBox, array: Array):
	if Constants.is_structure(new_hit_box.type):
		array.push_front(new_hit_box)
	else:
		array.append(new_hit_box)




func set_active(new_status: bool):
	active = new_status
	if active:
		emit_signal("activated")

func set_alive(new_status: bool):
	alive = new_status
	if not alive:
		emit_signal("died")

func set_highlighted(is_highlighted: bool):
	highlighted = is_highlighted
	get_node(graphics_node).handle_highlighted(highlighted)



func has_hit_box(hit_box: ObjectHitBox) -> bool:
	return overlapping_hit_boxes.has(hit_box)

func is_active() -> bool:
	return active and alive

func is_alive() -> bool:
	return alive

func get_highlighted() -> bool:
	return highlighted

func get_hit_points_max() -> float:
	return hit_points_max

func get_indestructible() -> bool:
	return indestructible
