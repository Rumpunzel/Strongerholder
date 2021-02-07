class_name HurtBox, "res://class_icons/game_objects/resources/icon_hurt_box.svg"
extends Area2D


var _damage_source: Node2D = null
var _attack_value: float = 0.0


onready var _hurt_shape: CollisionShape2D = $HurtShape




func _ready() -> void:
	connect("body_entered", self, "_hit_object")




func start_attack(_game_actor: Node2D, attack_value: float) -> void:
	_damage_source = _game_actor
	_attack_value = attack_value
	_hurt_shape.disabled = false


func end_attack() -> void:
	_damage_source = null
	_attack_value = 0.0
	_hurt_shape.disabled = true



func _hit_object(other_object: PhysicsBody2D) -> void:
	if other_object == _damage_source:
		return
	
	other_object.damage(_attack_value, _damage_source)
