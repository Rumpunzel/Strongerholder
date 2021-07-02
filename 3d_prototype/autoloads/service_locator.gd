extends Node


var _registered_services: Dictionary = { }


func register_service(service: Node) -> void:
	assert(service)
	_registered_services[service.get_class()] = service

func unregister_service(service: Node) -> bool:
	assert(service)
	return _registered_services.erase(service.get_class())


func get_service(service_class: GDScript) -> Node:
	# warning-ignore:unsafe_method_access
	return _registered_services[service_class.get_service_class()]
