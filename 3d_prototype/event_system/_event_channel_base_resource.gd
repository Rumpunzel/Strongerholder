class_name EventChannelBaseResource, "res://editor_tools/class_icons/resources/icon_aerial_signal.svg"
extends Resource

# warning-ignore:unused_class_variable
export(String, MULTILINE) var _description := ""

func _has_connections(signal_name: String) -> bool:
	if not get_signal_connection_list(signal_name).empty():
		return true
	else:
		push_warning("signal %s on %s not connected to anything, emission skipped" % [ signal_name, resource_path ])
		return false
