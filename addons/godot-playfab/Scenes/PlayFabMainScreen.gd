@tool
extends Control

var editor_resource_filesystem_cached

func _ready():
	# Needed, so can ater refresh the "FileSystem" panel of the Editor
	editor_resource_filesystem_cached = EditorPlugin.new().get_editor_interface().get_resource_filesystem()

func _on_SaveModel_pressed() -> void:

	if !guard_class_name_set():
		return

	var file_dialog: FileDialog = $FileDialog
	file_dialog.current_file = $VBoxContainer/ClassNameContainer/LineEdit.text + ".gd"
	file_dialog.show()
	file_dialog.connect("file_selected",Callable(self,"_on_file_selected").bind(),CONNECT_ONE_SHOT)


func _on_save_direct_pressed() -> void:

	if !guard_class_name_set():
		return

	var file_name: String = $VBoxContainer/ClassNameContainer/LineEdit.text + ".gd"
	var file_path: String = "res://addons/godot-playfab/Models/" + file_name
	_on_file_selected(file_path)


func _on_file_selected(file_path: String):

	var model: String = to_model($VBoxContainer/ClassNameContainer/LineEdit.text, $VBoxContainer/Input.text)
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
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


func to_model(object_name: String, input: String) -> String:
	var lines: PackedStringArray = input.split("\n", true)
	lines = remove_empty_lines(lines)
	lines.push_back("") # Hack: add an empty line at the bottom so below logic works & is simpler :-) Otherwise, the last prop would not be written

	var props: Array[Variant] = []
	var prop_line: int = 0
	var current_prop: Dictionary[String, String] = {}
	for line in lines:
		print(line)

		var str_line: String = (line as String).strip_edges()

		match prop_line:
			0: # Variable name
				current_prop["name"] = "var " + str_line
			1:	# Type
				str_line = fix_type(str_line)
				if not str_line.is_empty() and not str_line.begins_with("#"):
					current_prop["type"] = ": %s" % str_line
				else:
					print ("No type specified for property %s, defaulting to Variant" % current_prop.get("name", "UNKNOWN"))
					current_prop["type"] = "Variant"
			2:	# Comment
				current_prop["comment"] = "## %s" % [str_line]

		prop_line += 1
		if prop_line > 2:
			props.append(current_prop)
			current_prop = {}
			prop_line = 0

	var model: String = "extends JsonSerializable\nclass_name " + object_name + "\n\n"
	for prop in props:
		model += prop["comment"] + "\n"
		model += prop["name"] + prop["type"] + "\n"
		model += "\n\n"

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

func fix_type(type: String) -> String:

	match type:
		"string":
			return "String"
		"boolean":
			return "bool"
		"number":
			return "float"
		"object":
			return "Dictionary[String, Variant]"
		_:
			if type.ends_with("[]"):
				# Example: CatalogItem[] --> Array[CatalogItem]
				var inner_type: String = type.substr(0, type.length() - 2)
				return "Array[%s]" % inner_type
			return type


func remove_empty_lines(lines: PackedStringArray) -> PackedStringArray:
	var result: PackedStringArray = []
	for line in lines:
		if not line.strip_edges().is_empty():
			result.append(line)
	return result
