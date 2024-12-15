class_name CharacterController, "res://editor_tools/class_icons/spatials/icon_barbute.svg"
extends KinematicBody
tool

signal attacked(started)
signal item_picked_up(item)
signal gave_item(item, amount)
signal took_item(item, amount)
signal operated()

signal item_equipped(equipment)
signal item_unequipped(equipment)

signal current_interaction_changed(interaction)

export(Resource) var movement_stats
export(NodePath) var _hand_position

export var _equip_first_item := true

# INPUTS
# Vector3 position to move to
var destination_input: Vector3
# Vector3 direciton to move along
var movement_input := Vector3.ZERO
# Input triggers
var sprint_input := false
var jump_input := false

# ACTIONS
var horizontal_movement_vector := Vector2.ZERO setget set_horizontal_movement_vector
var vertical_velocity := 0.0
var moving_to_destination := false
var target_speed := 1.0
var current_interaction: Target = null setget set_current_interaction

var velocity := Vector3.ZERO setget set_velocity
var is_grounded := false
var look_position := Vector3.ZERO

var _avoid_obstacles: bool
var _equipped_item := EquippedItem.new()

onready var inventory: Inventory = $Inventory
onready var interaction_area: ObjectTrackingArea = $InteractionArea
onready var hurt_box: HurtBox = $HurtBox
onready var animation_tree: AnimationTree = $AnimationTree

onready var _ground_check: RayCast = $GroundCheck
onready var _navigation_agent: NavigationAgent = $NavigationAgent


func _ready() -> void:
	if Engine.editor_hint:
		return
	
	set_axis_lock(PhysicsServer.BODY_AXIS_ANGULAR_Y, true)
	destination_input = translation
	
	if _navigation_agent.avoidance_enabled and movement_stats.avoid_obstacles:
		_avoid_obstacles = true
		# warning-ignore:return_value_discarded
		_navigation_agent.connect("velocity_computed", self, "set_velocity")
	else:
		_avoid_obstacles = false
	
	# warning-ignore:return_value_discarded
	inventory.connect("equipment_stack_added", self, "_on_equipment_stack_added")

func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		return
	
	velocity = move_and_slide(velocity)
	is_grounded = _ground_check.is_colliding()
	
	if abs(look_position.x) > 0.1 or abs(look_position.z) > 0.1:
		_turn_to_look_postion(delta)


func horizontal_move_action(is_aerial_movement := false) -> void:
	if moving_to_destination:
		_navigation_agent.set_target_location(destination_input)
	else:
		var move_speed: float = target_speed * movement_stats.move_speed
		if is_aerial_movement:
			move_speed *= movement_stats.aerial_modifier
		
		horizontal_movement_vector.x = movement_input.x * move_speed
		horizontal_movement_vector.y = movement_input.z * move_speed

func apply_movement_vector() -> Vector3:
	var horizontal_movement: Vector2
	
	if moving_to_destination:
		if not _navigation_agent.is_navigation_finished():
			var destination := _navigation_agent.get_next_location()
			var direction := destination - translation
			direction.y = translation.y
			direction = direction.normalized()
			
			horizontal_movement = Vector2(direction.x, direction.z) * movement_stats.move_speed
		else:
			horizontal_movement = Vector2.ZERO
	else:
		horizontal_movement = horizontal_movement_vector
	
	var new_movement_vector := Vector3(
		horizontal_movement.x,
		-vertical_velocity,
		horizontal_movement.y
	)
	
	if is_avoiding_obstacles() and moving_to_destination:
		_navigation_agent.set_velocity(new_movement_vector)
	else:
		velocity = new_movement_vector
	
	if horizontal_movement != Vector2.ZERO:
		look_position = new_movement_vector * 100.0 + translation
	
	return velocity

func null_movement() -> void:
	destination_input = translation
	horizontal_movement_vector = Vector2.ZERO
	velocity = Vector3.DOWN * vertical_velocity


func get_potential_interaction(object: Node) -> Target:
	var interaction_resource: ItemResource = null
	
	if object is CollectableItem:
		return ItemInteraction.new(object, ObjectInteraction.InteractionType.PICK_UP, interaction_resource, 1)
	
	if object is Stash:
		return ItemInteraction.new(object, ItemInteraction.InteractionType.TRADE, interaction_resource, 1)
	
	if object is Workstation and (object as Workstation).can_be_operated():
		return ItemInteraction.new(object, ObjectInteraction.InteractionType.OPERATE, interaction_resource, 1)
	
	if hurt_box.can_attack_object(object, _equipped_item.stack.item):
		return ObjectInteraction.new(object, ObjectInteraction.InteractionType.ATTACK)
	
	return null


func attack(started: bool) -> void:
	if started:
		hurt_box.damage_hit_boxes(_equipped_item.stack.item)
	emit_signal("attacked", started)

func pick_up(item_node: CollectableItem) -> void:
	# WAITFORUPDATE: remove this unnecessary thing after 4.0
	# warning-ignore:unsafe_property_access
	var item: ItemResource = item_node.item_resource
	emit_signal("item_picked_up", item)
	# TODO: properly destroy item instead of only freeing
	item_node.queue_free()

func give(stash: Stash, item: ItemResource, amount: int) -> void:
	# warning-ignore:return_value_discarded
	stash.stash(item, amount)
	emit_signal("gave_item", item, amount)

func operate(workstation: Workstation) -> void:
	workstation.operate()
	emit_signal("operated")

func take(stash: Stash, item: ItemResource, amount: int) -> void:
	# warning-ignore:return_value_discarded
	stash.take(item, amount)
	emit_signal("took_item", item, amount)


func set_horizontal_movement_vector(new_vector: Vector2) -> void:
	horizontal_movement_vector = new_vector
	if horizontal_movement_vector != Vector2.ZERO:
		moving_to_destination = false


func is_avoiding_obstacles() -> bool:
	return _navigation_agent.avoidance_enabled and movement_stats.avoid_obstacles

func get_target_desired_distance() -> float:
	return _navigation_agent.target_desired_distance


func save_to_var(save_file: File) -> void:
	save_file.store_var(transform)
	save_file.store_8(_equipped_item.stack_id)

func load_from_var(save_file: File) -> void:
	transform = save_file.get_var()
	var current_stack_id: int = save_file.get_8()
	if current_stack_id >= 0 and current_stack_id < inventory.item_slots.size():
		equip_item_stack(inventory.item_slots[current_stack_id])


func set_velocity(new_velocity: Vector3) -> void:
	velocity = new_velocity


func get_navigation() -> WorldScene:
	assert(get_parent() as WorldScene)
	return get_parent() as WorldScene


func _turn_to_look_postion(delta: float) -> void:
	look_position.y = translation.y
	var new_transform := transform.looking_at(look_position, Vector3.UP)
	new_transform.basis = new_transform.basis.rotated(Vector3.UP, PI)
	transform = transform.interpolate_with(new_transform, movement_stats.turn_rate * delta)
	look_position = Vector3.ZERO


func equip_item_stack(equipment_stack: Inventory.ItemStack) -> void:
	assert(get_node(_hand_position))
	
	# warning-ignore:return_value_discarded
	unequip()
	
	_equipped_item.set_stack(inventory.item_slots.find(equipment_stack), equipment_stack, get_node(_hand_position))
	emit_signal("item_equipped", _equipped_item)

func unequip() -> bool:
	if _equipped_item.stack_id >= 0:
		emit_signal("item_unequipped", _equipped_item)
		_equipped_item.unequip()
		return true
	
	return false

func has_equipped(equipment_stack: Inventory.ItemStack) -> bool:
	# TODO: make this a nicer check
	return equipment_stack and equipment_stack == inventory.item_slots[_equipped_item.stack_id]

func has_something_equipped() -> bool:
	return _equipped_item.stack_id >= 0

func _on_equipment_stack_added(new_equipment_stack: Inventory.ItemStack) -> void:
	if _equip_first_item and _equipped_item.stack_id < 0:
		equip_item_stack(new_equipment_stack)


func set_current_interaction(new_interaction: Target) -> void:
	if current_interaction == new_interaction:
		return
	
	if current_interaction:
		undib_node(current_interaction.node, self)
	
	current_interaction = new_interaction
	emit_signal("current_interaction_changed", current_interaction)
	
	if current_interaction:
		dib_node(current_interaction.node, self)


func reset() -> void:
	set_current_interaction(null)


static func dib_node(node: Node, for_character: CharacterController) -> void:
	if node_is_dibbable(node):
		# warning-ignore:unsafe_method_access
		node.call_dibs(for_character, true)

static func undib_node(node: Node, for_character: CharacterController) -> void:
	if node_is_dibbable(node):
		# warning-ignore:unsafe_method_access
		node.call_dibs(for_character, false)

static func node_is_dibbable(node: Node) -> bool:
	return node != null and node.has_method("call_dibs")


class Target:
	const ANIMATION_PARAMETER := "parameters/%s/active"
	
	var node: Spatial
	
	func _init(new_node: Spatial) -> void:
		node = new_node
	
	func position() -> Vector3:
		return node.global_transform.origin
	
	func to_animation_parameter() -> String:
		return ""

class ItemInteraction extends Target:
	enum InteractionType {
		GIVE,
		TAKE,
		TRADE,
	}

	var interaction_type: int
	var item_resource: ItemResource
	var item_amount: int
	
	func _init(new_node: Spatial, new_interaction_type: int, new_resource: ItemResource, new_item_amount: int).(new_node) -> void:
		interaction_type = new_interaction_type
		item_resource = new_resource
		item_amount = new_item_amount
	
	func to_animation_parameter() -> String:
		match interaction_type:
			InteractionType.GIVE:
				return ANIMATION_PARAMETER % "give"
			InteractionType.TAKE:
				return ANIMATION_PARAMETER % "take"
			_:
				assert(false, "This animation is not supported for ItemInteractions!")
		
		return ""

class ObjectInteraction extends Target:
	enum InteractionType {
		ATTACK,
		OPERATE,
		PICK_UP,
	}
	
	var interaction_type: int
	
	func _init(new_node: Spatial, new_interaction_type: int).(new_node) -> void:
		interaction_type = new_interaction_type
	
	func to_animation_parameter() -> String:
		match interaction_type:
			InteractionType.ATTACK:
				return "attack"
			InteractionType.OPERATE:
				return "operate"
			InteractionType.PICK_UP:
				return "pick_up"
			_:
				assert(false, "This animation is not supported for ObjectInteractions!")
		
		return ""


class EquippedItem:
	var stack_id: int = -1
	var stack: Inventory.ItemStack = Inventory.ItemStack.new(null)
	var node: Spatial = null
	
	func unequip() -> void:
		stack_id = -1
		stack = Inventory.ItemStack.new(null)
		if node:
			node.queue_free()
			node = null
	
	func set_stack(new_stack_id: int, new_stack: Inventory.ItemStack, hand_position: Spatial) -> void:
		assert(new_stack)
		assert(hand_position)
		stack_id = new_stack_id
		
		stack = new_stack
		if stack.item:
			node = stack.item.attach_to(hand_position)
		elif node:
			node.queue_free()
			node = null



func _get_configuration_warning() -> String:
	# Data
	if not movement_stats:
		return "MovementStats are required"
	if not movement_stats is CharacterMovementStatsResource:
		return "MovementStats are of the wrong type"
	if not _hand_position:
		return "HandPosition path is required"
	
	return ""
