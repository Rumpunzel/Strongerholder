class_name InteractionHUD
extends Popup

export(Resource) var _player_interaction_channel

var _current_interaction: InteractionArea.Interaction
var _interaction_node: Node

onready var _icon: TextureRect = $VBoxContainer/Icon
onready var _arrow: TextureRect = $VBoxContainer/Arrow
onready var _tween: Tween = $Tween



func _ready() -> void:
	_player_interaction_channel.connect("raised", self, "_on_player_interaction_changed")
	
	var duration := 0.5
	var property := "rect_position:y"
	var y_pos_start := _arrow.rect_position.y
	var y_pos_end := y_pos_start + 4.0
	
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(_arrow, property, y_pos_start, y_pos_end, duration, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(_arrow, property, y_pos_end, y_pos_start, duration, Tween.TRANS_BACK, Tween.EASE_OUT, duration)


func _process(_delta: float) -> void:
	if not _current_interaction:
		return
	
	if not _current_interaction.type == InteractionArea.InteractionType.NONE and weakref(_interaction_node).get_ref():
		# warning-ignore-all:unsafe_property_access
		rect_position = get_viewport().get_camera().unproject_position(_interaction_node.global_transform.origin) - rect_pivot_offset



func _on_player_interaction_changed(interaction: InteractionArea.Interaction) -> void:
	_current_interaction = interaction
	
	if _current_interaction:
		_interaction_node = _current_interaction.node
		var _object_resource: ObjectResource = null
		
		if _interaction_node is Stash:
			_object_resource = _interaction_node.item_to_store
		
		if _object_resource:
			_icon.texture = _object_resource.icon
			popup()
			# warning-ignore:return_value_discarded
			_tween.start()
	elif visible:
		hide()
		# warning-ignore:return_value_discarded
		_tween.stop_all()
