class_name CityStructure, "res://assets/icons/structures/icon_city_structure.svg"
extends GameObject



func is_blocked() -> bool:
	return $hit_box.is_blocked()
