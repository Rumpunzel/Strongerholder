extends GUTTest




func test_saving_and_loading():
	var new_main: Main = autoqfree(load("res://main.tscn").instance())

	add_child(new_main)

	assert_true(not new_main == null, "If the node was instanced")

	new_main.queue_free()
