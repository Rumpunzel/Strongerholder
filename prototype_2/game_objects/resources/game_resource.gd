class_name GameResource, "res://class_icons/game_objects/resources/icon_resource.svg"
extends GameObject


const SCENE := "res://game_objects/resources/game_resource.tscn"

const PERSIST_PROPERTIES_2 := ["can_carry"]


signal item_picked_up
signal item_transferred
signal item_dropped


const DROP_RADIUS := 16.0
const DROP_SPEED := 0.2
const DROP_HEIGHT := 16.0


# warning-ignore-all:unused_class_variable
var can_carry: int = 1


onready var _quarter_master = ServiceLocator.quarter_master
onready var _tween: Tween = $Tween




func _ready() -> void:
	connect("died", self, "unregister_resource")
	
	register_resource()




func drop_item(position_to_drop: Vector2) -> void:
	_state_machine.drop_item(_objects_layer, position_to_drop)


func pick_up_item(new_inventory) -> void:
	_state_machine.pick_up_item(new_inventory)


func transfer_item(new_inventory) -> void:
	_state_machine.transfer_item(new_inventory)



func register_resource() -> void:
	 _quarter_master.register_resource(self)

func unregister_resource() -> void:
	_quarter_master.unregister_resource(self)




func _initialise_state_machine(new_state_machine: ObjectStateMachine = ResourceStateMachine.new()) -> void:
	._initialise_state_machine(new_state_machine)
	
	_state_machine.connect("item_picked_up", self, "_on_item_picked_up")
	_state_machine.connect("item_transferred", self, "_on_item_transferred")
	_state_machine.connect("item_dropped", self, "_on_item_dropped")



func _on_item_picked_up(new_inventory: Inventory) -> void:
	position = Vector2()
	get_parent().remove_child(self)
	new_inventory.call_deferred("_add_item", self)
	
	emit_signal("item_picked_up")


func _on_item_transferred(new_inventory: Inventory) -> void:
	get_parent().remove_child(self)
	new_inventory.call_deferred("_add_item", self)
	
	emit_signal("item_transferred")


func _on_item_dropped(position_to_drop: Vector2) -> void:
	var parent: Node2D = get_parent()
	
	if parent:
		parent.remove_child(self)
	
	_objects_layer.call_deferred("add_child", self)
	
	global_position = position_to_drop
	call_deferred("_play_drop_animation")
	
	emit_signal("item_dropped")


func _play_drop_animation() -> void:
	var final_position := global_position + Vector2(DROP_RADIUS - randf() * 2.0 * DROP_RADIUS, randf() * 2.0 * DROP_RADIUS)
	
	_tween.interpolate_property(self, "global_position:x", global_position.x, final_position.x, DROP_SPEED, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	_tween.interpolate_property(self, "global_position:y", global_position.y, final_position.y - DROP_HEIGHT, DROP_SPEED * 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	_tween.interpolate_property(self, "global_position:y", final_position.y - DROP_HEIGHT, final_position.y, DROP_SPEED * 0.5, Tween.TRANS_QUAD, Tween.EASE_IN, DROP_SPEED * 0.5)
	
	_tween.start()
