class_name StockpileStackAttributes
extends Resource

# warning-ignore-all:unused_class_variable
export(int, 1, 32) var x_size := 1
export(int, 1, 32) var z_size := 1
export(int, 1, 64) var y_size := 1

export var item_height := 1.0

export var alternate_rotation := true


func pallet_size() -> int:
	return x_size * z_size

func stack_size() -> int:
	return x_size * z_size * y_size

func position_in_stack(item: Spatial, index: int, stack_rotated: bool, square_size: float) -> void:
	var level := int(index / float(pallet_size()))
	var rotated := (alternate_rotation and (level % 2 == 1))
	if alternate_rotation and stack_rotated:
		rotated = not rotated
	
	var x := (index % x_size) * (square_size / float(x_size))
	var z := (index % z_size) * (square_size / float(z_size))
	var y := level * item_height
	
	var origin := Vector3(x, y, z) if not rotated else Vector3(square_size - z, y, x)
	item.transform.origin = origin
	
	if rotated:
		item.rotate_y(-PI / 2.0)
	
	return 
