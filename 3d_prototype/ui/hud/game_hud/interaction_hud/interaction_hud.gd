class_name InteractionHUD
extends Popup

export(Resource) var _player_interaction_channel

var _current_interaction: InteractionArea.Interaction
var _interaction_node: Node


func _ready() -> void:
	_player_interaction_channel.connect("raised", self, "_on_player_interaction_changed")

func _process(_delta: float) -> void:
	if not _current_interaction:
		return
	
	if not _current_interaction.type == InteractionArea.InteractionType.NONE and weakref(_interaction_node).get_ref():
		# warning-ignore-all:unsafe_property_access
		rect_position = get_viewport().get_camera().unproject_position(_interaction_node.global_transform.origin) - rect_pivot_offset


func _on_player_interaction_changed(interaction: InteractionArea.Interaction) -> void:
	_current_interaction = interaction
	
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	if _current_interaction:
		_interaction_node = _current_interaction.node
		var item_resource: ItemResource = null
		
		if _interaction_node is Stash:
			item_resource = _interaction_node.item_to_store
		
		if item_resource:
			_set_items(_interaction_node.inventory, item_resource)
			popup()
			return
	
	if visible:
		hide()


func _set_items(inventory: Inventory, item_resource: ItemResource) -> void:
	var contents := inventory.contents(false)
	var inventory_size := contents.size()
	var stack_size: int = item_resource.stack_size
	
	for slot in range(inventory_size):
		for stack_index in range(stack_size):
			var icon := TextureRect.new()
			icon.texture = item_resource.icon
			icon.expand = true
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon.rect_min_size = Vector2(40.0, 40.0)
			
			var stack: Inventory.ItemStack = contents[slot]
			icon.modulate = Color.white if stack.item and stack_index < stack.amount else Color.gray
			
			add_child(icon)
			
			var half_amount := inventory_size * stack_size * 0.5
			var index := slot * stack_size + stack_index + 0.5 - half_amount
			var x_pos := index * 48.0
			var y_pos := 64.0 - cos(index / ceil(half_amount * 0.4)) * 64.0
			
			icon.rect_position = Vector2(x_pos, y_pos)
