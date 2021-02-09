class_name ActorSpriteTree
extends GameSpriteTree


# warning-ignore:unused_signal
signal stepped(anim_name)




func _ready() -> void:
	_animations = [ "idle", "run", "attack", "give" ]
	
	_animation_player.connect("stepped", self, "_transfer_signal", ["stepped"])

