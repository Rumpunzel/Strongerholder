class_name InteractionHUD
extends Popup

export var _fade_in_duration := 0.1
export var _fade_out_duration := 0.5

export(Resource) var _player_interaction_channel

var _item_resource: ItemResource

var _current_interaction: InteractionArea.Interaction
var _interaction_node: Node

onready var _icon: TextureRect = $Icon
onready var _tween: Tween = $Tween


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	_player_interaction_channel.connect("raised", self, "_on_player_interaction_changed")

func _exit_tree() -> void:
	_player_interaction_channel.disconnect("raised", self, "_on_player_interaction_changed")


func _physics_process(_delta: float) -> void:
	if not _current_interaction:
		return
	
	if _current_interaction.type != InteractionArea.InteractionType.NONE and weakref(_interaction_node).get_ref():
		# warning-ignore-all:unsafe_property_access
		rect_position = get_viewport().get_camera().unproject_position(_interaction_node.global_transform.origin) - rect_pivot_offset


func _on_player_interaction_changed(interaction: InteractionArea.Interaction) -> void:
	if _current_interaction == interaction:
		return
	
	_current_interaction = interaction
	
	if visible:
		_hide()
	
	if _current_interaction:
		_interaction_node = _current_interaction.node
		_item_resource = null
		
		if _interaction_node is Stash:
			_item_resource = _interaction_node._item_to_store
		
		if _item_resource:
			_icon.texture = _item_resource.icon
			_popup()


func _popup() -> void:
	popup()
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "modulate:a", 0.0, 1.0, _fade_in_duration)
	# warning-ignore:return_value_discarded
	_tween.start()


func _hide() -> void:
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "modulate:a", 1.0, 0.0, _fade_out_duration)
	# warning-ignore:return_value_discarded
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	
	hide()
