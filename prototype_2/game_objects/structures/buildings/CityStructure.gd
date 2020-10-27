class_name CityStructure, "res://assets/icons/structures/icon_city_structure.svg"
extends Structure



func assign_gatherer(puppet_master: Node2D, gathering_resource):
	_pilot_master.assign_gatherer(puppet_master, gathering_resource)

func unassign_gatherer(puppet_master: Node2D, gathering_resource):
	_pilot_master.unassign_gatherer(puppet_master, gathering_resource)

func can_be_gathered(gathering_resource) -> bool:
	return _pilot_master.can_be_gathered(gathering_resource)


func operate():
	_state_machine.operate()

func can_be_operated() -> bool:
	return _pilot_master.can_be_operated()


func request_item(request, receiver: Node2D):
	var requested_item: Node2D = _pilot_master.has_item(request)
	
	if requested_item:
		_state_machine.give_item(requested_item, receiver)



func _get_copy_of_collision_shape() -> CollisionShape2D:
	return $collision_shape.duplicate() as CollisionShape2D


func _get_copy_sprite() -> Sprite:
	return $sprite.duplicate() as Sprite
