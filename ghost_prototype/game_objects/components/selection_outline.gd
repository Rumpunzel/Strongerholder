class_name SelectionOutline
extends Node2D
tool


export var radius: float = 12.0
export var point_count: int = 32
export var line_width: float = 1.0
export(Color) var color: Color = Color("ffd700")




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _draw() -> void:
	#draw_circle(Vector2.ZERO, radius, color)
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, point_count, color, line_width, true)
