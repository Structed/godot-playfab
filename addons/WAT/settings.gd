tool
extends Reference


static func initialize() -> void:
	if not ProjectSettings.has_setting("WAT/Test_Directory"):
		push_warning("Test Directory was set to project root.\nYou may change any setting for WAT in Project -> ProjectSettings -> General -> WAT")
	_add_setting("Test_Directory", TYPE_STRING, "res://")
	_add_setting("Results_Directory", TYPE_STRING, "res://")
	_add_setting("Test_Metadata_Directory", TYPE_STRING, "res://")
	_add_setting("Tags", TYPE_STRING_ARRAY, PoolStringArray())
	_add_setting("Cache_Tests", TYPE_BOOL, true)
	_add_setting("Window_Size", TYPE_VECTOR2, Vector2(1280, 720))
	_add_setting("Minimize_Window_When_Running_Tests", TYPE_BOOL, false)
	_add_setting("Port", TYPE_INT, 6008)
	_add_setting("Tags", TYPE_STRING_ARRAY, PoolStringArray())
	
	# Set this to true if using external editors
	ProjectSettings.save()
	
static func _add_setting(title: String, type: int, value, hint_type: int = -1, hint_string = "") -> void:
	title = title.insert(0, "WAT/")
	if ProjectSettings.has_setting(title):
		return
	ProjectSettings.set(title, value)
	var prop: Dictionary = {}
	prop["name"] = title
	prop["type"] = type
	if hint_type > -1:
		prop["hint"] = hint_type
		prop["hint_string"] = hint_string
	ProjectSettings.add_property_info(prop)

static func test_directory() -> String:
	return ProjectSettings.get_setting("WAT/Test_Directory")
	
static func results_directory() -> String:
	return ProjectSettings.get_setting("WAT/Results_Directory")
	
static func metadata_directory() -> String:
	return ProjectSettings.get_setting("WAT/Test_Metadata_Directory")
	
static func window_size() -> Vector2:
	return ProjectSettings.get_setting("WAT/Window_Size")
	
static func tags() -> PoolStringArray:
	return ProjectSettings.get_setting("WAT/Tags")

static func cache_tests() -> bool:
	return ProjectSettings.get_setting("WAT/Cache_Tests")
	
static func minimize_window_when_running_tests() -> bool:
	return ProjectSettings.get_setting("WAT/Minimize_Window_When_Running_Tests")
	
static func port() -> int:
	return ProjectSettings.get_setting("WAT/Port")

static func is_bottom_panel() -> int:
	return ProjectSettings.get_setting("WAT/Display") == 8
