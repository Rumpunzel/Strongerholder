extends Spatial


# Called when the node enters the scene tree for the first time.
func _ready():
	var rm = RingMap.new()
	$hill.setup(rm)
	
	var pl = preload("res://prefabs/gameactors/player/Player.tscn").instance()
	pl.setup(rm)
	add_child(pl)
	
	var np = preload("res://prefabs/gameactors/npcs/NPC.tscn").instance()
	np.setup(rm)
	add_child(np)
