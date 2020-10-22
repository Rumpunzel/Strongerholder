class_name JobStateIdle
extends JobState


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	for use in dedicated_tool.delivers:
		pass
	
	for use in dedicated_tool.gathers:
		var nearest_resource: GameResource = _get_nearest_item_of_type(use)
		
		if nearest_resource:
			exit(PICK_UP, [nearest_resource, employer])
			return
		
		
		var nearest_structure: Structure = _get_nearest_structure_holding_item_of_type(use)
		
		if nearest_structure:
			var state: String = GATHER
			
			if nearest_structure is CityStructure:
				if nearest_structure.can_be_gathered(use):
					state = RETRIEVE
				else:
					continue
			
			exit(state, [use, nearest_structure, employer])
			return
