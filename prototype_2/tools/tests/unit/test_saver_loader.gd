extends GUTTest


var test_run_time: float = 1.0



func test_saving_and_loading():
	var main_node: Main = get_tree().current_scene
	
	assert_true(not main_node == null, "If the node was instanced")
	
	main_node._enter_world(load("res://game_world/world_scenes/test_scene/test.tscn"))
	yield(yield_for(test_run_time), YIELD)
	#main_node._world = true
	
	
	var previous_main_state := _get_state_of_node(main_node._world)
	
#	for key in previous_main_state.keys():
#		gut.p("%s%s" % [ key, previous_main_state[key] ])
#		break
	
	main_node.save_game()
	yield(yield_to(main_node, 'game_save_finished', 10), YIELD)
	
	main_node.load_game()
	yield(yield_to(main_node, 'game_load_finished', 10), YIELD)
	
	var state_after_loading := _get_state_of_node(main_node._world)
	
#	for key in state_after_loading.keys():
#		gut.p("%s%s" % [ key, state_after_loading[key] ])
#		break
	
	var differences_between_the_states := _get_differences_between_to_dicts(previous_main_state, state_after_loading)
	
	for key in differences_between_the_states.keys():
		gut.p("Comparing %s: %s" % [ key, differences_between_the_states[key] ])
		assert_true(false, "There should have bee no difference for %s: %s" % [ key, differences_between_the_states[key] ])
	
	
#	var differences_between_the_states_rev := _get_differences_between_to_dicts(state_after_loading, previous_main_state)
#
#	for difference in differences_between_the_states_rev:
#		assert_true(false)


func _get_state_of_node(node_to_get: Node) -> Dictionary:
	var node_state := { }
	var node_path := node_to_get.get_path()
	
	#if "PERSIST_AS_PROCEDURAL_OBJECT" in node_to_get and node_to_get.get("PERSIST_AS_PROCEDURAL_OBJECT"):
	node_state[node_path] = { }
	
	for property in node_to_get.get_property_list():
		node_state[node_path][property] = node_state.get(property)
#	else:
#		gut.p("%s is not prodedural" % node_path)
	
	for child in node_to_get.get_children():
		node_state[child.get_path()] = _get_state_of_node(child)
	
	return node_state


func _get_differences_between_to_dicts(first_state: Dictionary, second_state: Dictionary) -> Dictionary:
	var differences := { }
	
	for key in first_state.keys():
		if not second_state.get(key, null):
			differences[key] = null
		else:
			match typeof(first_state[key]):
				TYPE_ARRAY:
					continue
				TYPE_DICTIONARY:
					var diffs := _get_differences_between_to_dicts(first_state[key], second_state[key])
					
					if not diffs.empty():
						pass
						#differences[key] = diffs
				_:
					if not first_state[key] == second_state[key]:
						differences[key] = [ first_state[key], second_state[key] ]
	
	return differences
