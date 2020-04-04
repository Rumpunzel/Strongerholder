extends Navigation



func _ready():
	randomize()
	
	var rm = RingMap.new()
	
	$navigation_mesh/city_structures.build_everything(rm)
	$flora.grow_flora(rm)
	
	$navigation_mesh
	
	var pl = preload("res://prefabs/gameactors/player/Player.tscn").instance()
	pl.setup(rm)
	add_child(pl)
	
	var np = preload("res://prefabs/gameactors/npcs/NPC.tscn").instance()
	np.setup(rm)
	add_child(np)
