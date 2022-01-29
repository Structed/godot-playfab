tool
extends EditorPlugin



func _init() -> void:

	add_custom_project_setting(PlayFabConstants.SETTING_PLAYFAB_TITLE_ID, "", TYPE_STRING, PROPERTY_HINT_PLACEHOLDER_TEXT, "Retieve from PlayFab Game Manager")

	var error: int = ProjectSettings.save()
	if error: push_error("Encountered error %d when saving project settings." % error)


func _enter_tree():
	pass


func _exit_tree():
	pass


func add_custom_project_setting(name: String, default_value, type: int, hint: int = PROPERTY_HINT_NONE, hint_string: String = "") -> void:

	if ProjectSettings.has_setting(name): return

	var setting_info: Dictionary = {
		"name": name,
		"type": type,
		"hint": hint,
		"hint_string": hint_string
	}

	ProjectSettings.set_setting(name, default_value)
	ProjectSettings.add_property_info(setting_info)
	ProjectSettings.set_initial_value(name, default_value)
