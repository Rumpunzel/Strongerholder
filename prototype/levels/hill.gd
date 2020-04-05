extends Spatial



func _ready():
	randomize()
	
	var rm = RingMap.new()
	
	$city_structures.build_everything(rm)
	$flora.grow_flora(rm)
	
	var pl = preload("res://prefabs/gameactors/player/Player.tscn").instance()
	pl.setup(rm)
	add_child(pl)
	pl.set_ring_vector(RingVector.new(0, 0, true))
	
	var np = preload("res://prefabs/gameactors/GameActor.tscn").instance()
	np.setup(rm)
	add_child(np)
	np.set_ring_vector(RingVector.new(0, 0, true))
