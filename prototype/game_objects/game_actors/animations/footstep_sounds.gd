extends AudioStreamPlayer3D


export(NodePath) var animation_player_node: String
export(String, DIR) var step_sounds: String


onready var sounds: Array = FileHelper.list_files_in_directory(step_sounds, false, ".wav")
onready var animation_player: AnimationPlayer = get_node(animation_player_node)



# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.connect("stepped", self, "play_step_sound")



func play_step_sound():
	play_audio_from_array(sounds)


func play_audio_from_array(audio_array:Array):
	if not audio_array.empty():
		stream = load(audio_array[randi() % audio_array.size()])
		play()
