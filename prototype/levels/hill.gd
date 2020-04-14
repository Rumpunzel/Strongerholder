class_name Hill, "res://assets/icons/icon_hill.svg"
extends Spatial


export(PackedScene) var camera

export(PackedScene) var game_actor



func _ready():
	randomize()
	
	var new_camera = camera.instance()
	add_child(new_camera)
	
	for i in range(2):#CityLayout.get_number_of_segments(0)):
		var actor_type: int
		
		if i == 0:
			actor_type = Constants.Actors.PLAYER
		elif i % 2 == 1:
			actor_type = Constants.Actors.WOODSMAN
		else:
			actor_type = Constants.Actors.CARPENTER
		
#		var new_actor = GameActor.new(actor_type, RingVector.new(0, i, true))
		
		var new_character: GameActor = game_actor.instance()
		add_child(new_character)
		new_character._setup(RingVector.new(0, i, true), i == 0)
		
		if i == 0:
			new_camera.set_node_to_follow(new_character)
	
	$city_structures.build_everything()
	$flora.grow_flora()
