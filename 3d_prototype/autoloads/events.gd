extends Node

# warning-ignore-all:unused_signal

# Management signal
signal new_game_started()
signal game_quit()

# Menu signals
signal main_menu_requested()


# Gameplay signal
signal player_instantiated(player_node)
signal player_freed()

signal scene_loaded()
signal scene_unloaded()

signal camera_changed(camera_node)
