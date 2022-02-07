#tool
extends Control


func _on_Generate_pressed():
	var model = to_model($ClassNameContainer/LineEdit.text, $Input.text)
	$Output.text = model


static func to_model(object_name: String, input: String) -> String:
	var lines = input.split("\n", true)
	
	var props = []
	var current_prop = ""
	var prop_line = 0
	for line in lines:
		
		var str_line = (line as String).strip_edges()
		
		if not str_line.empty():
			match prop_line:
				0:
					current_prop = str_line
				1:
					current_prop = "var %s: %s" % [current_prop, str_line] 
				2:
					current_prop = "# %s\n%s" % [str_line, current_prop]
			
			prop_line += 1
		else:
			props.append(current_prop)
			prop_line = 0
		
	var model = "extends Reference\nclass_name " + object_name + "\n\n"
	for prop in props:
		model += prop + "\n\n"
	return model
