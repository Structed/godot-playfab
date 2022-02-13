tool
extends Control



func _on_SaveModel_pressed():
	
	if $VBoxContainer/ClassNameContainer/LineEdit.text.empty():
		$ErrorPopupDialog/Label.text = "Please first enter a Class Name!"
		$ErrorPopupDialog.popup_centered(Vector2(0,0))
		return
		
	var file_dialog = $FileDialog
	file_dialog.current_file = $VBoxContainer/ClassNameContainer/LineEdit.text + ".gd"
	file_dialog.show()
	file_dialog.connect("file_selected", self, "_on_file_selected")
	
	
func _on_file_selected(file_path: String):
	
	var model = to_model($VBoxContainer/ClassNameContainer/LineEdit.text, $VBoxContainer/Input.text)
	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_string(model)
	file.close()


static func to_model(object_name: String, input: String) -> String:
	var lines = input.split("\n", true)
	lines.push_back("") # Hack: add an empty line at the bottom so below logic works & is simpler :-) Otherwise, the last prop would not be written
	
	var props = []
	var current_prop = ""
	var prop_line = 0
	for line in lines:
		
		var str_line = (line as String).strip_edges()
		
		if not str_line.empty():
			match prop_line:
				0: # Variable name
					current_prop = "var " + str_line
				1:	# Type
					str_line = fix_type(str_line)
					if not str_line.empty() and not str_line.begins_with("#"):
						current_prop += ": %s" % str_line
					else:
						current_prop = str_line
				2:	# Comment
					current_prop = "# %s\n%s" % [str_line, current_prop]
			
			prop_line += 1
		else:
			props.append(current_prop)
			prop_line = 0
		
	var model = "extends Reference\nclass_name " + object_name + "\n\n"
	for prop in props:
		model += prop + "\n\n"
	return model

static func fix_type(type: String) -> String:
	
	match type:
		"string":
			return "String"
		"boolean":
			return "bool"
		_:
			if type.ends_with("]"):
				return "Array"
			return type


