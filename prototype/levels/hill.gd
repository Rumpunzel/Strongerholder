extends Spatial



func _ready():
	randomize()
	
	var rm = RingMap.new()
	
	$city_structures.build_everything(rm)
	$flora.grow_flora(rm)
	
	for i in range(CityLayout.get_number_of_segments(0)):
		var np = preload("res://prefabs/gameactors/GameActor.tscn").instance()
		add_child(np)
		np.setup(rm, RingVector.new(0, i, true), 1 if i == 0 else 0)
