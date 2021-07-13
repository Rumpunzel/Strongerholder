extends Node

# warning-ignore-all:unused_class_variable
var main: MainChannel = MainChannel.new()
var menu: MenuChannel = MenuChannel.new()
var gameplay: GameplayChannel = GameplayChannel.new()
var player: PlayerChannel = PlayerChannel.new()
var hud: HUDChannel = HUDChannel.new()


# warning-ignore-all:unused_signal
class MainChannel:
	# Emited whenever gameplay commences for the first time
	signal game_started()
	signal game_quit()
	
	signal game_save_started()
	signal game_save_finished()
	signal game_load_started()
	signal game_load_finished()
	
	signal game_paused()
	signal game_unpaused()


class MenuChannel:
	signal main_menu_requested()


class GameplayChannel:
	signal new_game()
	
	signal scene_loaded(scene)
	signal scene_unloaded(scene)
	
	signal node_spawned(node, position)


class PlayerChannel:
	signal player_registered(player_node)
	signal player_unregistered(player_node)
	
	signal camera_changed(camera_node)


class HUDChannel:
	signal inventory_stacks_updated(inventory)
	signal inventory_updated(inventory)
	signal inventory_hud_toggled()
	
	signal equipment_stacks_updated(equipment)
	signal equipment_updated(equipment)
	signal equipment_hud_toggled()
