extends Spatial


export(PackedScene) var camera


func _ready():
	randomize()
	
	var ring_map = RingMap.new()
	
	$city_structures.build_everything(ring_map)
	$flora.grow_flora(ring_map)
	
	var new_camera = camera.instance()
	add_child(new_camera)
	
	for i in range(CityLayout.get_number_of_segments(0)):
		var actor_type: int
		
		if i == 0:
			actor_type = Constants.Objects.PLAYER
		elif i % 2 == 1:
			actor_type = Constants.Objects.WOODSMAN
		else:
			actor_type = Constants.Objects.CARPENTER
		
		var new_actor = GameActor.new(actor_type, RingVector.new(0, i, true), ring_map)
		add_child(new_actor)
		
		if i == 0:
			new_camera.set_node_to_follow(new_actor.object)
