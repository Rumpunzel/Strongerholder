extends Particles2D


var _material: ParticlesMaterial

var _base_intitial_velocity: float
var _base_direction: Vector3




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_material = (process_material.duplicate() as ParticlesMaterial)
	process_material = _material
	
	_base_intitial_velocity = _material.initial_velocity
	_base_direction = _material.direction
	
	emitting = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




func _on_moved(new_velocity: Vector2) -> void:
	var new_length: float = new_velocity.length()
	
	if new_length > 0:
		emitting = true
		
		_material.initial_velocity = new_length * 0.5
		_material.direction.x = -abs(new_velocity.x)
		_material.direction.y = new_velocity.y
	else:
		emitting = false
		
		_material.initial_velocity = _base_intitial_velocity
		_material.direction = _base_direction
