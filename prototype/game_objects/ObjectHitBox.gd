class_name ObjectHitBox, "res://assets/icons/icon_hit_box.svg"
extends Area


signal added_object(game_object)
signal highlighted
signal activated
signal died


export(NodePath) var _inventory_node

export var hit_points_max: float = 10.0 setget , get_hit_points_max
export var indestructible: bool = false setget , get_indestructible


var active: bool = false setget set_active, is_active
var alive: bool = false setget set_alive, is_alive
var highlighted: bool = false setget set_highlighted, get_highlighted


var _overlapping_hit_boxes: Array = [ ]
var _inactive_overlapping_hit_boxes: Array = [ ]


onready var _inventory: Inventory = get_node(_inventory_node)

onready var hit_points: float = hit_points_max




# Called when the node enters the scene tree for the first time.
func _ready():
	owner.connect("activate", self, "initialize")
	
	connect("area_entered", self, "entered")
	connect("area_exited", self, "exited")




func initialize():
	set_alive(true)
	
	connect("died", owner, "object_died")


func damage(damage_points: float, sender: ObjectHitBox) -> bool:
	hit_points -= damage_points
	
	#print("%s damaged %s for %s damage." % [sender.name, name, damage_points])
	
	if not indestructible and hit_points <= 0:
		die(sender)
		return false
	
	return true


func die(sender: ObjectHitBox):
	set_alive(false)
	
	_inventory._send_all_items(sender._inventory)
	
	owner.get_node("collision_shape").disabled = true
	owner.visible = false
	owner.set_process(false)


func offer_item(item, receiver: ObjectHitBox):
	_inventory.request_item(item, receiver._inventory)


func request_item(item, sender: ObjectHitBox):
	sender.offer_item(item, self)



func entered(new_hit_box: ObjectHitBox):
	if parse_entering_hit_box(new_hit_box):
		emit_signal("added_object", new_hit_box)


func exited(new_hit_box: ObjectHitBox):
	parse_exiting_hit_box(new_hit_box)



func parse_entering_hit_box(new_hit_box: ObjectHitBox) -> bool:
	if new_hit_box.active:
		if not _overlapping_hit_boxes.has(new_hit_box):
			add_hit_box_to_array(new_hit_box, _overlapping_hit_boxes)
			new_hit_box.connect("died", self, "parse_exiting_hit_box", [new_hit_box])
			
			return true
	elif not _inactive_overlapping_hit_boxes.has(new_hit_box):
		add_hit_box_to_array(new_hit_box, _inactive_overlapping_hit_boxes)
		new_hit_box.connect("activated", self, "parse_acitvating_hit_box", [new_hit_box])
		new_hit_box.connect("died", self, "parse_exiting_hit_box", [new_hit_box])
		
	return false


func parse_exiting_hit_box(new_hit_box: ObjectHitBox):
	if _overlapping_hit_boxes.has(new_hit_box):
		_overlapping_hit_boxes.erase(new_hit_box)
		new_hit_box.disconnect("died", self, "parse_exiting_hit_box")
		
	elif _inactive_overlapping_hit_boxes.has(new_hit_box):
		_inactive_overlapping_hit_boxes.erase(new_hit_box)
		new_hit_box.disconnect("activated", self, "parse_acitvating_hit_box")
		new_hit_box.disconnect("died", self, "parse_exiting_hit_box")


func parse_acitvating_hit_box(new_hit_box: ObjectHitBox):
	if _inactive_overlapping_hit_boxes.has(new_hit_box):
		_inactive_overlapping_hit_boxes.erase(new_hit_box)
		new_hit_box.disconnect("activated", self, "parse_acitvating_hit_box")
		new_hit_box.disconnect("died", self, "parse_exiting_hit_box")
		parse_entering_hit_box(new_hit_box)


func add_hit_box_to_array(new_hit_box: ObjectHitBox, array: Array):
	if Constants.is_structure(new_hit_box.type):
		array.push_front(new_hit_box)
	else:
		array.append(new_hit_box)




func set_active(new_status: bool):
	if not active and new_status:
		emit_signal("activated")
	
	active = new_status

func set_alive(new_status: bool):
	if alive and not new_status:
		emit_signal("died")
	
	alive = new_status
	set_active(is_active())

func set_highlighted(is_highlighted: bool):
	highlighted = is_highlighted
	emit_signal("highlighted", highlighted)



func has_object(object) -> ObjectHitBox:
	if _overlapping_hit_boxes.has(object):
		return object
	
	for hit_box in _overlapping_hit_boxes:
		if hit_box.owner == object:
			return hit_box
	
	return null

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

func get_hit_points() -> float:
	return hit_points
