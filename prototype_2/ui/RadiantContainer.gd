class_name RadiantContainer
extends CenterContainer


export(float, 0, 360) var _container_angle = 360

export var _center_children: bool = true
export var _be_a_retard: bool = false


var circle_center: Control setget , get_circle_center




func _ready():
	for child in .get_children():
		if not child == circle_center:
			.remove_child(child)
			add_child(child)



func update_children():
	var children = get_children()
	var circle_radius = min(rect_size.x, rect_size.y) * 0.5
	
	for i in children.size():
		var child = children[i]
		var child_number = (ceil(i / 2.0) * (1 if i % 2 == 0 else -1)) if _be_a_retard else i
		var child_ratio: float = float(child_number) / float(children.size())
		var child_angle = child_ratio * deg2rad(_container_angle)
		
		child.rect_position = Vector2(0, -circle_radius).rotated(child_angle)
		
		if _center_children:
			child.rect_position -= child.rect_size / 2.0
			child.rect_pivot_offset = Vector2(child.rect_size.x * (1.0 - 2.0 * abs(child_ratio - 0.25)), child.rect_size.y * (1.0 - 2.0 * abs(child_ratio - 0.5)))



func add_child(node: Node, _legible_unique_name: bool = false):
	get_circle_center().add_child(node)


func get_children() -> Array:
	return get_circle_center().get_children()


func get_child_count() -> int:
	return get_circle_center().get_child_count()


func remove_child(node: Node):
	get_circle_center().remove_child(node)



func add_actual_child(node: Node):
	.add_child(node)


func remove_actual_child(node: Node):
	.remove_child(node)



func get_circle_center() -> Control:
	if not circle_center:
		circle_center = Control.new()
		.add_child(circle_center)
		connect("resized", self, "update_children")
	
	return circle_center
