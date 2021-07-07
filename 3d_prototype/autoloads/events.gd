extends Node

# warning-ignore-all:unused_class_variable
var main: MainChannel = MainChannel.new()
var menu: MenuChannel = MenuChannel.new()
var gameplay: GameplayChannel = GameplayChannel.new()
var player: PlayerChannel = PlayerChannel.new()
var hud: HUDChannel = HUDChannel.new()


# warning-ignore-all:unused_signal
class MainChannel:
	signal game_started()
	signal continued()
	signal game_quit()
	
	signal game_paused()
	signal game_unpaused()


class MenuChannel:
	signal main_menu_requested()


class GameplayChannel:
	signal scene_loaded()
	signal scene_unloaded()


class PlayerChannel:
	signal player_instantiated(player_node)
	signal player_freed()
	
	signal camera_changed(camera_node)


class HUDChannel:
	signal inventory_updated(inventory)
	signal inventory_hud_toggled()
	
	signal equipment_updated(equipment)
	signal equipment_hud_toggled()
