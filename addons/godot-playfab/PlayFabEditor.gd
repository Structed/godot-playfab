@tool
extends EditorPlugin

const MainPanel = preload("res://addons/godot-playfab/Scenes/PlayFabMainScreen.tscn")

var main_panel_instance

func _init():

	add_custom_project_setting(PlayFabConstants.SETTING_PLAYFAB_TITLE_ID, "", TYPE_STRING, PROPERTY_HINT_PLACEHOLDER_TEXT, "Retieve from PlayFab Game Manager")

	var error: int = ProjectSettings.save()
	if error: push_error("Encountered error %d when saving project settings." % error)


func _enter_tree():
	add_autoload_singleton("PlayFabManager", "res://addons/godot-playfab/PlayFabManager.gd")

	main_panel_instance = MainPanel.instantiate()
	# Add the main panel to the editor's main viewport.
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	_make_visible(false)


func _exit_tree():
	remove_autoload_singleton("PlayFabManager")

	if main_panel_instance:
		main_panel_instance.queue_free()

func _has_main_screen():
	return true


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func _get_plugin_name():
	return "PlayFab"


func _get_plugin_icon():
	return load("res://addons/godot-playfab/icon_16x16.png")


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
