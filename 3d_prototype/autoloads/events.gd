extends Node

# warning-ignore-all:unused_signal

# Management signal
signal game_started()
signal continued()
signal game_quit()

signal game_paused()
signal game_unpaused()

# Menu signals
signal main_menu_requested()


# Gameplay signal
signal player_instantiated(player_node)
signal player_freed()

signal scene_loaded()
signal scene_unloaded()

signal camera_changed(camera_node)


# HUD signals


# In-world UX
signal clicked_to_move(position)
