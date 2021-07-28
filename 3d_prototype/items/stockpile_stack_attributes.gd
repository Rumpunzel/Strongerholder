class_name StockpileStackAttributes
extends Resource

# warning-ignore-all:unused_class_variable
export(int, 1, 32) var x_size := 1
export(int, 1, 32) var z_size := 1
export(int, 1, 64) var y_size := 1

export var item_height := 1.0

export var alternate_rotation := true


func max_stack_size() -> int:
	return x_size * z_size * y_size
