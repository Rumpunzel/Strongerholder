class_name InventorySlot
extends Button

signal item_stack_dropped(item_stack, position, sender)

var item_stack: ItemStack

var _dragging := false

onready var _inventory_item: Control = $InventoryItem
onready var _icon: TextureRect = $InventoryItem/Icon
onready var _amount: Label = $InventoryItem/Amount
onready var _highlight: TextureRect = $InventoryItem/Highlight



func _ready() -> void:
	remove()
	# warning-ignore-all:return_value_discarded
	connect("focus_entered", self, "_set_hover")
	connect("focus_exited", self, "_set_default")
	connect("mouse_entered", self, "_set_hover")
	connect("mouse_exited", self, "_set_default")


func _process(_delta: float):
	if _dragging:
		_inventory_item.rect_global_position = get_global_mouse_position() - rect_size * 0.5



func add(new_item_stack: ItemStack) -> void:
	item_stack = new_item_stack
	var amount := item_stack.amount
	
	if amount > 0:
		_icon.texture = item_stack.item.icon
		_amount.text = ("%d" % amount) if amount > 1 else ""
		_inventory_item.visible = true
		disabled = false
	else:
		remove()


func remove() -> void:
	disabled = true
	_inventory_item.visible = false
	_highlight.visible = false
	
	item_stack = null
	_icon.texture = null
	_amount.text = ""



func _on_button_down() -> void:
	_dragging = true

func _on_button_up() -> void:
	_dragging = false
	emit_signal("item_stack_dropped", item_stack, get_global_mouse_position(), self)
	_correct_position()

func _correct_position() -> void:
	_inventory_item.rect_position = Vector2.ZERO


func _set_default() -> void:
	if disabled:
		return
	_highlight.visible = false

func _set_hover() -> void:
	if disabled:
		return
	_highlight.visible = true
