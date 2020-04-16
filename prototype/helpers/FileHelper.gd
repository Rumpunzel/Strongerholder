class_name FileHelper
extends Resource


static func list_files_in_directory(directory_path:String, recursive:bool = false, file_suffix:String = "", as_dictionary = false):
	var files = [ ]
	var directory: Directory = Directory.new()
	
	directory.open(directory_path)
	directory.list_dir_begin(true)
	
	while true:
		var file = directory.get_next()
		
		if file == "":
			break
		elif directory.current_is_dir():
			if recursive:
				files += list_files_in_directory(directory_path.plus_file(file), recursive, file_suffix)
		elif file.ends_with(file_suffix):
			var file_path = directory_path.plus_file(file)
			
			files.append(file_path)
	
	directory.list_dir_end()
	
	if as_dictionary:
		var dic_files: Dictionary = { }
		
		for file in files:
			dic_files[file.get_file().trim_suffix(file_suffix)] = file
		
		files = dic_files
	
	return files


static func delete_file(file_path:String):
	var directory: Directory = Directory.new()
	directory.remove(file_path)
