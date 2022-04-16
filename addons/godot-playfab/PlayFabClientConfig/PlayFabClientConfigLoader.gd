extends Reference
class_name PlayFabClientConfigLoader

const DEBUG_DO_NOT_ENCRYPT = false  # Only works on debug builds
const SECTION_NAME = "PlayFab"

var _load_path = "user://playfab_client_config.cfg"
var _config: ConfigFile = ConfigFile.new()
var _title_id: String
var _errors = []


func save(password: String, new_config: PlayFabClientConfig):
	_set_values(new_config)

	if OS.is_debug_build() && DEBUG_DO_NOT_ENCRYPT:
		_config.save(_load_path)
	else:
		_config.save_encrypted_pass(_load_path, password)


func load(password: String) -> PlayFabClientConfig:
	_config = ConfigFile.new()
	var new_config = PlayFabClientConfig.new()
	var err: int

	if OS.is_debug_build() && DEBUG_DO_NOT_ENCRYPT:
		err = _config.load(_load_path)
	else:
		err = _config.load_encrypted_pass(_load_path, password)

	# If the file didn't load, ignore it.
	if err != OK:
		var error_message = "Config file didn't load. Error code: %f" % err
		print_debug(error_message)
		_errors.append(error_message)
		return PlayFabClientConfig.new()

	_get_values(new_config)

	return new_config


func _set_values(new_config: PlayFabClientConfig):
	var props = new_config.get_property_list()

	for i in range(3, props.size()):
		var name = props[i].name
		_config.set_value(SECTION_NAME, name, new_config.get(name))


func _get_values(new_config: PlayFabClientConfig):
	var props = new_config.get_property_list()

	for i in range(3, props.size()):
		var name = props[i].name
		if _config.has_section_key(SECTION_NAME, name):
			var value = _config.get_value(SECTION_NAME, name)
			new_config.set(name, value)
