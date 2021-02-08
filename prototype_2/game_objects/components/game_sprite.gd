class_name GameSprite
extends Sprite


signal acted
signal action_finished
signal animation_finished


onready var _animation_tree: GameSpriteTree = $AnimationTree




func _ready() -> void:
	_animation_tree.connect("acted", self, "_on_animation_acted")
	_animation_tree.connect("action_finished", self, "_on_action_finished")
	_animation_tree.connect("animation_finished", self, "_on_animation_finished")




func travel(new_animation: String) -> void:
	_animation_tree.travel(new_animation)


func set_blend_positions(new_positions: Vector2) -> void:
	_animation_tree.set_blend_positions(new_positions)


func get_current_animation() -> String:
	return _animation_tree.get_current_animation()


func get_copy_sprite() -> Sprite:
	return (duplicate() as Sprite)



func _on_animation_acted(animation: String) -> void:
	emit_signal("acted", animation)

func _on_action_finished(animation: String) -> void:
	emit_signal("action_finished", animation)

func _on_animation_finished(animation: String) -> void:
	emit_signal("animation_finished", animation)
