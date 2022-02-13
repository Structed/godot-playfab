#tool
extends Control


func _on_Generate_pressed():
	var model = to_model($ClassNameContainer/LineEdit.text, $Input.text)
	$Output.text = model


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
