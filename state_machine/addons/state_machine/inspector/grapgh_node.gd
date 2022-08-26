extends GraphNode
tool

signal delete_requested()

enum SlotTypes {
	TO_CONDITION,
	TO_SLOT,
}

func _on_deleted() -> void:
	emit_signal("delete_requested")
