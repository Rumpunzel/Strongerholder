tool
extends Spatial


# Called when the node enters the scene tree for the first time.
func setup(new_ring_map:RingMap):
	$city_structures.build_everything(new_ring_map)
