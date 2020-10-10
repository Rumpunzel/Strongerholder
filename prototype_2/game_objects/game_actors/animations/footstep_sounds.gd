extends GameAudioPlayer


export(NodePath) var _animation_player_node: String
export(String, DIR) var _step_sounds: String


onready var _sounds: Array = FileHelper.list_files_in_directory(_step_sounds, false, ".wav")
onready var _animation_player: AnimationPlayer = get_node(_animation_player_node)



# Called when the node enters the scene tree for the first time.
func _ready():
	_animation_player.connect("stepped", self, "play_step_sound")



func play_step_sound():
	play_audio_from_array(_sounds)
