class_name Hill, "res://assets/icons/icon_hill.svg"
extends Spatial


export(PackedScene) var camera

export(PackedScene) var game_actor
export(PackedScene) var woodsman
export(PackedScene) var carpenter



func _ready():
	randomize()
	
	$city_structures.build_everything()
	$flora.grow_flora()
	
	var new_camera: PlayerCamera = camera.instance()
	add_child(new_camera)
	
	for i in range(CityLayout.get_number_of_segments(0)):
		var new_character: GameActor
		
		if i == 0:
			new_character = game_actor.instance()
		elif i % 2 == 1:
			new_character = carpenter.instance()
		else:
			new_character = woodsman.instance()
		
		add_child(new_character)
		new_character._setup(RingVector.new(0, i, true), i == 0)
		
		if i == 0:
			new_camera.set_node_to_follow(new_character)
