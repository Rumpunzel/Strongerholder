extends GUTTest



func test_files():
	assert_true(not _get_all_saved_scripts().empty(), "Testing if anything is saved.")



func test_scenes_declared_correctly():
	var all_saved_scripts: Array =  _get_all_saved_scripts()
	assert_true(not all_saved_scripts.empty(), "Make sure there are scripts.")
	
	for file in all_saved_scripts:
		var script: GDScript = load(file) as GDScript
		var problem_at_counter: int
		
		problem_at_counter = _test_script_scenes(script)
		assert_true(problem_at_counter < 0, "Testing if SCENE constants are correctly declared in: %s, the index %d is wrong!" % [ file, problem_at_counter ])

func _test_script_scenes(script: GDScript) -> int:
	var scene := "SCENE"
	var postfix := "_OVERRIDE"
	var post_fix_2 := "_%d"
	var test_up_to := 10
	
	for counter in range(2, test_up_to):
		if "%s%s%s" % [ scene, postfix, post_fix_2 % (counter - 1) if counter > 2 else "" ] in script:
			if not "%s%s%s" % [ scene, postfix if counter > 2 else "", post_fix_2 % (counter - 2) if counter > 3 else "" ] in script:
				gut.p("Error at index %d" % counter)
				return counter
		
	return -1



func test_arrays_to_be_saved():
	var all_saved_scripts: Array =  _get_all_saved_scripts()
	assert_true(not all_saved_scripts.empty(), "Make sure there are scripts.")
	
	var persist_properties := "PERSIST_PROPERTIES"
	var persist_obj_properties := "PERSIST_OBJ_PROPERTIES"
	
	for file in all_saved_scripts:
		var script: GDScript = load(file) as GDScript
		var problem_at_counter: int
		
		problem_at_counter = _test_script_arrays(script, persist_properties)
		assert_true(problem_at_counter < 0, "Testing if PERSIST_PROPERTIES constants are correctly declared in: %s, the index %d is wrong!" % [ file, problem_at_counter ])
		
		problem_at_counter = _test_script_arrays(script, persist_obj_properties)
		assert_true(problem_at_counter < 0, "Testing if PERSIST_OBJ_PROPERTIES constants are correctly declared in: %s, the index %d is wrong!" % [ file, problem_at_counter ])

func _test_script_arrays(script: GDScript, constant_to_check: String) -> int:
	var postfix := "_%d"
	var test_up_to := 10
	
	for counter in range(2, test_up_to):
		if "%s%s" % [ constant_to_check, postfix % counter] in script:
			if not "%s%s" % [ constant_to_check, (postfix % (counter - 1)) if counter > 2 else "" ] in script:
				return counter
	
	return -1



func test_properties_saved():
	var all_saved_scripts: Array =  _get_all_saved_scripts()
	assert_true(not all_saved_scripts.empty(), "Make sure there are scripts.")
	
	var persist_properties := "PERSIST_PROPERTIES"
	var persist_obj_properties := "PERSIST_OBJ_PROPERTIES"
	
	for file in all_saved_scripts:
		var script = autofree(load(file).new())
		var properties_not_in_class: Array
		
		properties_not_in_class = _test_script_properties(script, persist_properties)
		assert_true(properties_not_in_class.empty(), "Testing if all PERSIST_PROPERTIES are members of: %s,  %s are not!" % [ file, properties_not_in_class ])
		
		properties_not_in_class = _test_script_properties(script, persist_obj_properties)
		assert_true(properties_not_in_class.empty(), "Testing if all PERSIST_OBJ_PROPERTIES are members of: %s,  %s are not!" % [ file, properties_not_in_class ])

func _test_script_properties(script, constant_to_check: String) -> Array:
	var properties_not_in_class: Array = [ ]
	var postfix := "_%d"
	var test_up_to := 10
	
	for counter in range(1, test_up_to):
		var array_to_check := "%s%s" % [ constant_to_check, (postfix % counter) if counter >= 2 else "" ]
		
		if array_to_check in script:
			for property in script.get(array_to_check):
				if not (property in script):
					properties_not_in_class.append(property)
	
	return properties_not_in_class




func _get_all_saved_scripts() -> Array:
	var all_saved_scripts: Array = [ ]
	var all_script_files: Array = FileHelper.list_files_in_directory("res://", true, ".gd")
	
	for file in all_script_files:
		var script: GDScript = load(file) as GDScript
		
		if "PERSIST_AS_PROCEDURAL_OBJECT" in script:
			all_saved_scripts.append(file)
	
	return all_saved_scripts
