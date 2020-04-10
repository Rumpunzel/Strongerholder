extends Spatial


export(PackedScene) var game_actor


func _ready():
	randomize()
	
	var ring_map = RingMap.new()
	
	$city_structures.build_everything(ring_map)
	$flora.grow_flora(ring_map)
	
	for i in range(CityLayout.get_number_of_segments(0)):
		var new_actor = game_actor.instance()
		var actor_type: int
		
		add_child(new_actor, true)
		
		if i == 0:
			actor_type = Constants.Objects.PLAYER
		elif i < CityLayout.get_number_of_segments(0) * 0.7:
			actor_type = Constants.Objects.WOODSMAN
		else:
			actor_type = Constants.Objects.CARPENTER
		
		new_actor.setup(ring_map, RingVector.new(0, i, true), actor_type)
