extends CenterContainer
class_name RadiantContainer


export var be_a_retard:bool = false


var circle_center:Control setget , get_circle_center


func _ready():
	for child in .get_children():
		if not child == circle_center:
			remove_child(child)
			add_child(child)



func update_children():
	var children = circle_center.get_children()
	var angle_offset:float = TAU / children.size() #in degrees
	var angle:float = 0.0 #in radians
	var circle_radius = min(rect_size.x, rect_size.y) * 0.5
	
	for i in children.size():
		var child = children[i]
		var child_angle = (ceil(i / 2.0) * (-1 if i % 2 == 0 else 1)) if be_a_retard else i
		
		child_angle = (child_angle / float(children.size())) * TAU
		
		child.rect_position = Vector2(0, -circle_radius).rotated(child_angle)



func add_child(node:Node, _legible_unique_name:bool = false):
	get_circle_center().add_child(node)


func get_children() -> Array:
	return get_circle_center().get_children()


func get_child_count() -> int:
	return get_circle_center().get_child_count()



func get_circle_center() -> Control:
	if not circle_center:
		circle_center = Control.new()
		.add_child(circle_center)
		connect("resized", self, "update_children")
	
	return circle_center
