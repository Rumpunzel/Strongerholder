extends Node

# warning-ignore-all:unused_class_variable
var main: MainChannel = MainChannel.new()
var gameplay: GameplayChannel = GameplayChannel.new()
var player: PlayerChannel = PlayerChannel.new()
var hud: HUDChannel = HUDChannel.new()


# warning-ignore-all:unused_signal
class MainChannel:
	# Emited whenever gameplay commences for the first time
	signal game_started()
	signal game_quit()
	
	# Saving
	signal game_save_started()
	signal game_save_finished()
	# Loading
	signal game_load_started()
	signal game_load_finished()
	
	# Pause Request
	signal game_pause_requested()
	signal game_continue_requested()
	# Pausing
	signal game_paused()
	signal game_continued()


class GameplayChannel:
	signal new_game()
	
	# Scenes
	signal scene_loaded(scene)
	signal scene_unloaded(scene)
	
	# Spawning
	signal node_spawned(node, position)


class PlayerChannel:
	# Spawning
	signal player_registered(player_node)
	signal player_unregistered(player_node)
	
	# Camera
	signal camera_changed(camera_node)


class HUDChannel:
	# Inventory
	signal inventory_stacks_updated(inventory)
	signal inventory_updated(inventory)
	signal inventory_hud_toggled()
	
	# Equipment
	signal equipment_stacks_updated(equipment)
	signal equipment_updated(equipment)
	signal equipment_hud_toggled()
	
	# Building
	signal building_hud_toggled()
