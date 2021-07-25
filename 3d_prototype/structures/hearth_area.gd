class_name HearthArea
extends Area

export(float, 1.0, 64.0, 1.0) var _minimum_range := 1.0
export(float, 1.0, 64.0, 1.0) var _maximum_range := 16.0

export(float, 0.0, 16.0) var _minimum_energy := 0.0
export(float, 0.0, 16.0) var _maximum_energy := 5.0

export(int, 1, 128) var _minimum_particles := 4
export(int, 1, 128) var _maximum_particles := 64

export(Resource) var _item_to_burn
export var _item_burn_duration := 60.0


var _shape: SphereShape

var _current_burn_duration := 0.0
var _current_burn_stage := 0
var _previous_burn_stage := 0


onready var _inventory: Inventory = Utils.find_node_of_type_in_children(owner, Inventory)
onready var _collision_shape: CollisionShape = $CollisionShape
onready var _light: OmniLight = $Light
onready var _particles: Particles = $Particles

onready var _burn_stages: int = _item_to_burn.stack_size
onready var _maximum_burn_duration := _burn_stages * _item_burn_duration



func _enter_tree() -> void:
	add_to_group(SavingAndLoading.PERSIST_DATA_GROUP)

func _ready() -> void:
	_shape = SphereShape.new()
	_collision_shape.shape = _shape
	_blaze()

func _process(delta: float) -> void:
	_burn(delta)
	_blaze()



func save_to_var(save_file: File) -> void:
	save_file.store_var(_current_burn_duration)

func load_from_var(save_file: File) -> void:
	_current_burn_duration = save_file.get_var()



func _burn(delta: float) -> void:
	_previous_burn_stage = _current_burn_stage
	_current_burn_duration = max(_current_burn_duration - delta, 0.0)
	_current_burn_stage = int(ceil(_current_burn_duration / _item_burn_duration))
	
	if _previous_burn_stage > _current_burn_stage:
		var left_in_stack := _inventory.use(_item_to_burn)
		assert(left_in_stack >= 0)
		_particles.amount = int(_value_from_range(_minimum_particles, _maximum_particles))


func _blaze() -> void:
	var burning := _current_burn_duration > 0.0
	_light.visible = burning
	_particles.emitting = burning
	
	if not burning:
		return
	
	var _range := _value_from_range(_minimum_range, _maximum_range)
	_light.omni_range = _range
	_light.light_energy = _value_from_range(_minimum_energy, _maximum_energy)
	
	_shape.radius = _range


func _value_from_range(min_value: float, max_value: float) -> float:
	var ratio := _current_burn_duration / _maximum_burn_duration
	return min_value + ratio * (max_value - min_value)


func _on_item_added(item: ItemResource) -> void:
	if item == _item_to_burn and _current_burn_duration < _maximum_burn_duration:
		_current_burn_duration += _item_burn_duration
