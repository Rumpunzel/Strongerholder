# GdUnit generated TestSuite
class_name controllerTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://characters/controllers/controller.gd'

func test_saving_and_loading() -> void:
	var file := File.new()
	var path := __source.get_base_dir()
	path = path.plus_file('test_file.save')
	
	var error := file.open(path, File.WRITE)
	assert_bool(error == OK)
	
	var source: Controller = load(__source).new()
	var table: TransitionTableResource = source._transition_table_resource
	
	source.save_to_var(file)
	file.close()
	
	
	error = file.open(path, File.READ)
	assert_bool(error == OK)
	
	source.load_from_var(file)
	var loaded_table: TransitionTableResource = source._transition_table_resource
	assert_bool(table == loaded_table)
	
	file.close()
	source.free()
