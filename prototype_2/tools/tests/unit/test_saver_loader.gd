extends GUTTest



func test_assert_true_with_true():
	assert_true(true, "Should pass, true is true")


func test_saving_and_loading():
	var new_main: Main = load("res://main.tscn").instance()
	
	add_child(new_main)
	
	assert_true(not new_main == null, "If the node was instanced")
	
	new_main.queue_free()
