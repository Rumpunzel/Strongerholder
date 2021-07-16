class_name BuildingPlacer
extends Spatial


export var _grid_size := 2.0

export(Resource) var _building_placement_confirmed_channel
export(Resource) var _building_placement_cancelled_channel


var current_structure: StructureResource setget _set_current_structure

var _objects_area := [ ]
var _model: Spatial = null


onready var _building_area: Area = $BuildingArea
onready var _collision_shape: CollisionShape = $BuildingArea/CollisionShape

onready var _ground_check: GroundCheck = $BuildingArea/GroundCheck
onready var _raycast: RayCast = $RayCast
onready var _tween: Tween = $Tween



func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	_building_placement_confirmed_channel.connect("raised", self, "_on_building_placement_confirmed")
	# warning-ignore:return_value_discarded
	_building_placement_cancelled_channel.connect("raised", self, "_set_current_structure", [ null ])

func _exit_tree() -> void:
	_building_placement_confirmed_channel.disconnect("raised", self, "_on_building_placement_confirmed")
	_building_placement_cancelled_channel.disconnect("raised", self, "_set_current_structure")


func _ready() -> void:
	_set_current_structure(null)

func _process(_delta: float) -> void:
	var current_camera: GameCamera = get_viewport().get_camera()
	var camera_ray := current_camera.mouse_as_world_point()
	
	_raycast.transform.origin = camera_ray.from
	_raycast.cast_to = camera_ray.to
	
	var mouse_position := _raycast.get_collision_point()
	var raster_position := Vector3(stepify(mouse_position.x, _grid_size), stepify(mouse_position.y, _grid_size), stepify(mouse_position.z, _grid_size))
	
	_building_area.translation = raster_position
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(_model, "translation", null, raster_position, 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_tween.start()
	_model.visible = is_space_legal()



func is_space_legal() -> bool:
	return _objects_area.empty() and _ground_check.is_valid()



func _on_building_placement_confirmed() -> void:
	if current_structure:
		# warning-ignore:return_value_discarded
		current_structure.place_at(_building_area.translation)


func _on_body_entered(body: Node):
	_objects_area.append(body)

func _on_body_exited(body: Node):
	_objects_area.erase(body)



func _set_current_structure(new_structure: StructureResource) -> void:
	var is_not_null := not new_structure == null
	
	current_structure = new_structure
	
	if _model:
		remove_child(_model)
		_model.queue_free()
		_model = null
	
	if is_not_null:
		var new_shape: BoxShape = current_structure.shape.duplicate()
		new_shape.extents *= 0.95
		_collision_shape.shape = new_shape
		_collision_shape.translation.y = current_structure.shape.extents.y
		
		_ground_check.set_shape(current_structure.shape)
		
		_model = current_structure.model.instance()
		add_child(_model)
	else:
		_collision_shape.shape = null
	
	_collision_shape.disabled = not is_not_null
	_raycast.enabled = is_not_null
	
	set_process(is_not_null)
