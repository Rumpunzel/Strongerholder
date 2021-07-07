class_name ItemResource
extends ObjectResource

# warning-ignore-all:unused_class_variable
export(int, 0, 64) var stack_size = 1


func _to_string() -> String:
	return "%s, Stack Size: %d" % [ ._to_string(), stack_size ]
