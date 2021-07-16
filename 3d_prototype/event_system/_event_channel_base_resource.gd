class_name EventChannelBaseResource
extends Resource

const RAISED := "raised"

export(String, MULTILINE) var _description := ""

func _has_connections(signal_name: String) -> bool:
	return not get_signal_connection_list(signal_name).empty()
