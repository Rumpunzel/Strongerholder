tool
extends Spatial
class_name GameObject

func is_class(class_type): return class_type == "GameObject" or .is_class(class_type)
func get_class(): return "GameObject"


const INTERACT_FUNCTION = "interact"
const DAMAGE_FUNCTION = "damage"
const GIVE_FUNCTION = "give"
const TAKE_FUNCTION = "take"

const EVERYTHING = "everything"


export var hit_points_max:float = 10.0
export var indestructible:bool = false


onready var hit_points:float = hit_points_max


# Reference to the ring_map; pseudo Singleton only availably to GameObjects
var ring_map:RingMap
# The position of the object in ring vector space
#	for further information, look into the documentation in the RingVector class
var ring_vector:RingVector = RingVector.new(0, 0) setget set_ring_vector, get_ring_vector

var highlighted:bool = false setget set_highlighted, get_highlighted

var inventory:Array = [ ] setget set_inventory, get_inventory


signal entered_segment
signal died



func _init(new_ring_map:RingMap = null):
	ring_map = new_ring_map


# Called when the node enters the scene tree for the first time.
func _ready():
	ring_vector.connect("vector_changed", self, "updated_ring_vector")


func setup(new_ring_map:RingMap):
	ring_map = new_ring_map



func updated_ring_vector():
	if ring_vector.radius <= CityLayout.get_radius_maximum(ring_vector.ring):
		emit_signal("entered_segment", ring_vector)


func handle_highlighted():
	pass


func interact(sender:GameObject) -> bool:
	print("%s interacted with %s." % [sender.name, name])
	
	return true


func give(new_items:Array, sender:GameObject):
	print("%s gave %s: %s" % [sender.name, name, new_items])
	
	while not new_items.empty():
		inventory.append(new_items.pop_front())


func take(objects, sender:GameObject):
	if objects == EVERYTHING:
		objects = inventory
	
	if objects is Array:
		sender.give(objects, self)


func damage(damage_points:float, sender:GameObject) -> bool:
	hit_points -= damage_points
	
	print("%s damaged %s for %s damage." % [sender.name, name, damage_points])
	
	if not indestructible and hit_points <= 0:
		die(sender)
		return false
	
	return true


func die(_sender:GameObject):
	emit_signal("died")




func set_ring_vector(new_vector:RingVector):
	ring_vector.set_equal_to(new_vector)


func set_highlighted(is_highlighted:bool):
	highlighted = is_highlighted
	handle_highlighted()


func set_inventory(new_inventory:Array):
	inventory = new_inventory



func get_ring_vector() -> RingVector:
	return ring_vector


func get_highlighted() -> bool:
	return highlighted


func get_inventory() -> Array:
	return inventory
