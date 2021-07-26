class_name InteractionHUD
extends Popup

export(PackedScene) var _interaction_icon
export var _empty_color := Color("bfbfbfbf")

export(Resource) var _player_interaction_channel
export(Resource) var _player_item_interaction_channel

var _inventory: Inventory
var _item_resource: ItemResource

var _current_interaction: InteractionArea.Interaction
var _interaction_node: Node

onready var _icons: Control = $Icons
onready var _icon: TextureRect = _interaction_icon.instance()
onready var _tween: Tween = $Tween


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	_player_interaction_channel.connect("raised", self, "_on_player_interaction_changed")
	# warning-ignore:return_value_discarded
	_player_item_interaction_channel.connect("raised", self, "_on_player_item_interaction_started")

func _exit_tree() -> void:
	_player_interaction_channel.disconnect("raised", self, "_on_player_interaction_changed")
	_player_item_interaction_channel.disconnect("raised", self, "_on_player_item_interaction_started")


func _ready() -> void:
	# warning-ignore:return_value_discarded
	_tween.connect("tween_all_completed", self, "_on_completed")

func _process(_delta: float) -> void:
	if not _current_interaction:
		return
	
	if not _current_interaction.type == InteractionArea.InteractionType.NONE and weakref(_interaction_node).get_ref():
		# warning-ignore-all:unsafe_property_access
		rect_position = get_viewport().get_camera().unproject_position(_interaction_node.global_transform.origin) - rect_pivot_offset
		_update_items()


func _on_player_interaction_changed(interaction: InteractionArea.Interaction) -> void:
	if _current_interaction == interaction:
		return
	
	_current_interaction = interaction
	
	if get_children().has(_icon):
		# warning-ignore:return_value_discarded
		_tween.stop_all()
		remove_child(_icon)
	
	for child in _icons.get_children():
		_icons.remove_child(child)
		child.queue_free()
	
	if _current_interaction:
		_interaction_node = _current_interaction.node
		_item_resource = null
		
		if _interaction_node is Stash:
			_item_resource = _interaction_node.item_to_store
		
		if _item_resource:
			_inventory = _interaction_node.inventory
			_set_items()
			_update_items()
			popup()
			return
	
	if visible:
		hide()
		_inventory = null


func _on_player_item_interaction_started(state: int) -> void:
	match state:
		ReadInteractionResource.ReadInteraction.InteractionState.STARTED:
			if not _item_resource:
				_on_completed()
				return
			
			if not get_children().has(_icon):
				var pos := Vector2()
				for icon in _icons.get_children():
					if icon is TextureRect and not icon.modulate == Color.white:
						pos = icon.rect_position
						break
				
				add_child(_icon)
				
				# warning-ignore:return_value_discarded
				_tween.interpolate_property(_icon, "rect_position", Vector2(0.0, 64.0), pos, 0.5)
				# warning-ignore:return_value_discarded
				_tween.start()
		
		ReadInteractionResource.ReadInteraction.InteractionState.CANCELLED:
			if get_children().has(_icon):
				# warning-ignore:return_value_discarded
				_tween.stop_all()
				remove_child(_icon)


func _on_completed() -> void:
	_player_item_interaction_channel.raise(ReadInteractionResource.ReadInteraction.InteractionState.COMPLETED)


func _set_items() -> void:
	var contents := _inventory.contents(false)
	var inventory_size := contents.size()
	var stack_size: int = _item_resource.stack_size
	
	for slot in range(inventory_size):
		for stack_index in range(stack_size):
			var icon: TextureRect = _interaction_icon.instance()
			icon.texture = _item_resource.icon
			_icon.texture = _item_resource.icon
			
			var half_amount := inventory_size * stack_size * 0.5
			var index := slot * stack_size + stack_index + 0.5 - half_amount
			var x_pos := index * 48.0
			var y_pos := 64.0 - cos(index / ceil(half_amount * 0.4)) * 64.0
			
			icon.rect_position = Vector2(x_pos, y_pos)
			
			_icons.add_child(icon)


func _update_items() -> void:
	if not _inventory:
		return
	
	var contents := _inventory.contents(false)
	var inventory_size := contents.size()
	var stack_size: int = _item_resource.stack_size
	var icons := _icons.get_children()
	
	for slot in range(inventory_size):
		for stack_index in range(stack_size):
			var i := slot * stack_size + stack_index
			var icon: TextureRect = icons[i]
			var stack: Inventory.ItemStack = contents[slot]
			
			icon.modulate = Color.white if stack.item and stack_index < stack.amount else _empty_color
