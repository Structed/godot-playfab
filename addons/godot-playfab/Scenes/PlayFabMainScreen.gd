@tool
extends Control

var editor_resource_filesystem_cached

func _ready():
	# Needed, so can ater refresh the "FileSystem" panel of the Editor
	editor_resource_filesystem_cached = EditorPlugin.new().get_editor_interface().get_resource_filesystem()

func _on_SaveModel_pressed():
	
	if !guard_class_name_set():
		return
		
	var file_dialog = $FileDialog
	file_dialog.current_file = $VBoxContainer/ClassNameContainer/LineEdit.text + ".gd"
	file_dialog.show()
	file_dialog.connect("file_selected",Callable(self,"_on_file_selected").bind(),CONNECT_ONE_SHOT)


func _on_save_direct_pressed():
	
	if !guard_class_name_set():
		return
		
	var file_name = $VBoxContainer/ClassNameContainer/LineEdit.text + ".gd"
	var file_path = "res://addons/godot-playfab/Models/" + file_name
	_on_file_selected(file_path)


func _on_file_selected(file_path: String):
	
	var model = to_model($VBoxContainer/ClassNameContainer/LineEdit.text, $VBoxContainer/Input.text)
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(model)

	# Refresh the "FileSystem" panel
	editor_resource_filesystem_cached.scan()
	
	print("Saved model to file path: \"%s\"" % file_path)
	

func guard_class_name_set() -> bool:
	if $VBoxContainer/ClassNameContainer/LineEdit.text.is_empty():
		$ErrorPopupDialog/Label.text = "Please first enter a Class Name!"
		$ErrorPopupDialog.popup_centered(Vector2(0,0))
		return false
		
	return true


static func to_model(object_name: String, input: String) -> String:
	var lines = input.split("\n", true)
	lines.push_back("") # Hack: add an empty line at the bottom so below logic works & is simpler :-) Otherwise, the last prop would not be written
	
	var props = []
	var current_prop = ""
	var prop_line = 0
	for line in lines:
		
		var str_line = (line as String).strip_edges()
		
		if not str_line.is_empty():
			match prop_line:
				0: # Variable name
					current_prop = "var " + str_line
				1:	# Type
					str_line = fix_type(str_line)
					if not str_line.is_empty() and not str_line.begins_with("#"):
						current_prop += ": %s" % str_line
					else:
						current_prop = str_line
				2:	# Comment
					current_prop = "# %s\n%s" % [str_line, current_prop]
			
			prop_line += 1
		else:
			props.append(current_prop)
			prop_line = 0
		
	var model = "extends JsonSerializable\nclass_name " + object_name + "\n\n"
	for prop in props:
		model += prop + "\n\n"
	
	# TODO: Find a way to generate the mapping for props automatically!
	model += """
func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass
	
	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
	
"""
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

