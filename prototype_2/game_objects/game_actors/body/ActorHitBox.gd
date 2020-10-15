class_name ActorHitBox, "res://assets/icons/game_actors/icon_actor_hit_box.svg"
extends ObjectHitBox



#func initialize():
#	.initialize()
	#owner.connect("entered_segment", self, "_move_building")




#func interact_with(other_hit_box: ObjectHitBox):
#	_resource_locator.interact_with(other_hit_box, self)



#func open_menu(new_menu: RadiantUI):
#	if not placing_this_building:
#		_animation_tree.travel("idle")
#
#		_animation_tree.can_act = false
#		new_menu.connect("closed", _animation_tree, "set_can_act", [true])
#		# TODO: HACK!
#		new_menu.display(get_tree().get_root().get_node("test/ui_layer/control/margin_container"))
#	elif not placing_this_building.is_blocked():
#		_animation_tree.travel("give")
#
#		yield(_animation_player, "acted")
#
#		if placing_this_building:
#			placing_this_building.activate_object()
#			placing_this_building = null
#	else:
#		_animation_tree.travel("give")



#func _move_building(new_vector):
##	if placing_this_building:
##		placing_this_building.ring_vector = RingVector.new(new_vector.ring, new_vector.segment, true)
#	pass
#
#
#
#func set_placing_this_building(new_object):
#	if new_object:
#		placing_this_building = new_object
#		get_tree().current_scene.get_node("viewport_container/viewport/hill/city_structures").add_child(placing_this_building)
#		_move_building(owner.ring_vector)
#	else:
#		get_tree().current_scene.get_node("viewport_container/viewport/hill/city_structures").remove_child(placing_this_building)
#		placing_this_building.queue_free()
#		placing_this_building = new_object
