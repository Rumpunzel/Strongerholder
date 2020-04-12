class_name RingObject
extends Spatial


signal entered_segment(ring_vector)
signal activated
signal died

signal received_item(item)
signal sent_item(item)


const INTERACT_FUNCTION = "interact"
const DAMAGE_FUNCTION = "damage"
const GIVE_FUNCTION = "receive_items"

const EVERYTHING = "everything"


export var hit_points_max: float = 10.0
export var indestructible: bool = false


# The position of the object in ring vector space
#	for further information, look into the documentation in the RingVector class
var ring_vector: RingVector = RingVector.new(0, 0) setget set_ring_vector, get_ring_vector

var type: int setget set_type, get_type
var object = null setget set_object, get_object

var active: bool = true setget set_active, is_active
var alive: bool = true setget set_alive, is_alive

var highlighted: bool = false setget set_highlighted, get_highlighted

var inventory: Array = [ ] setget set_inventory, get_inventory


# Reference to the ring_map; pseudo Singleton only availably to RingObjects
var ring_map: RingMap


onready var hit_points: float = hit_points_max




func _init(new_ring_map: RingMap = null):
	ring_map = new_ring_map


# Called when the node enters the scene tree for the first time.
func _ready():
	ring_vector.connect("vector_changed", self, "updated_ring_vector")




func setup(new_ring_map: RingMap, new_ring_vector:RingVector, new_type: int):
	ring_map = new_ring_map
	set_ring_vector(new_ring_vector)
	set_type(new_type)



func updated_ring_vector():
	emit_signal("entered_segment", ring_vector)


func handle_highlighted():
	pass


func interact(sender: RingObject) -> bool:
	print("%s interacted with %s." % [sender.name, name])
	
	return true


func receive_items(new_items: Array, sender: RingObject):
	for item in new_items:
		var new_item = sender.send_item(item, self) if sender else item
		
		if new_item:
			inventory.append(new_item)
			emit_signal("received_item", item)
			
#			if sender:
#				print("%s gave %s: %s" % [sender.name, name, Constants.enum_name(Constants.Objects, new_item)])


func send_item(item_to_send, _sender: RingObject):
	if inventory.has(item_to_send):
		inventory.erase(item_to_send)
		emit_signal("sent_item", item_to_send)
		
		return item_to_send
	else:
		return null


func damage(damage_points: float, delay: float = 0.0, sender: RingObject = null) -> bool:
	if delay > 0.0:
		var timer = Timer.new()
		add_child(timer)
		timer.start(delay)
		
		yield(timer, "timeout")
		
		timer.queue_free()
	
	hit_points -= damage_points
	
	#print("%s damaged %s for %s damage." % [sender.name, name, damage_points])
	
	if not indestructible and hit_points <= 0:
		die(sender)
		return false
	
	return true


func die(_sender: RingObject):
	set_alive(false)




func set_ring_vector(new_vector: RingVector):
	ring_vector.set_equal_to(new_vector)

func set_type(new_type: int):
	type = new_type
	name = Constants.enum_name(Constants.Objects, type)


func set_object(new_object):
	if object:
		remove_child(object)
		object.queue_free()
		object = null
	
	object = new_object
	
	object.transform.origin = Vector3(0, CityLayout.get_height_minimum(ring_vector.ring), ring_vector.radius)
	
	add_child(object)
	
	name = "[%s:(%s, %s)]" % [Constants.enum_name(Constants.Objects, type), ring_vector.ring, ring_vector.segment]


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
	handle_highlighted()

func set_inventory(new_inventory: Array):
	inventory = new_inventory



func get_ring_vector() -> RingVector:
	return ring_vector

func get_type() -> int:
	return type

func get_object():
	return object

func is_active() -> bool:
	return active and alive

func is_alive() -> bool:
	return alive

func get_highlighted() -> bool:
	return highlighted

func get_inventory() -> Array:
	return inventory
