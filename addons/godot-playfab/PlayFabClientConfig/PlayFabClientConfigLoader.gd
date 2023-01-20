extends RefCounted
class_name PlayFabClientConfigLoader

# Handles serialization/deserialization of a `PlayFabClientConfig` to `ConfigFile`


# Whether to encrypt the config file
# Will only work in Debug Mode
const DEBUG_DO_NOT_ENCRYPT = false  # Only works checked debug builds

# Section to write key/value paris to
const SECTION_NAME = "PlayFab"

# **Accessibility: protected/virtual**
# Path3D to load/save the ConfigFile from
# Should only be overridden in tests or extending classes
var _load_path = "user://playfab_client_config.cfg"

# **Accessibility: private**
# Holds the ConfigFile instance
var _config: ConfigFile = ConfigFile.new()

# An errors array.
# Will get filled if there are errors during loading of the ConfigFile
var errors = []


# Saves properties from @paramref `new_config`
# to an encrypted ConfigFile
# @param password: String - The password used to encrypt the ConfigFile
# @param new_config: PlayFabClientConfig - Object to retrieve key/values from
func save(password: String, new_config: PlayFabClientConfig):
	_set_values(new_config)
	_save(password)
	

# Actual file system save logic
# @param password: String - The password used to encrypt the ConfigFile
func _save(password: String):
	if OS.is_debug_build() && DEBUG_DO_NOT_ENCRYPT:
		_config.save(_load_path)
	else:
		_config.save_encrypted_pass(_load_path, password)


# Loads an encrypted ConfigFile from disk and returns a `PlayFabClientConfig`
# with all properties set from values of ConfigFile
# @paramref password: String - Password used for file enxryption
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
		if err == ERR_FILE_NOT_FOUND:
			print_debug("No config file found. After login, it will be created at \"%s\"." % _load_path)
		else:
			var error_message = "Config file didn't load. Error code: %f" % err
			print_debug(error_message)
			errors.append(error_message)

		return PlayFabClientConfig.new()

	_get_values(new_config)

	return new_config


# Clears the config\
# @param password: String - The password used to encrypt the ConfigFile
func clear(password: String):
	_config.clear()
	_save(password)


# Sets all property values from @paramref `new_config`checked `_config`
# @param new_config: PlayFabClientConfig - object to get property values from
func _set_values(new_config: PlayFabClientConfig):
	var props = new_config.get_property_list()

	for i in range(3, props.size()):
		var name = props[i].name
		_config.set_value(SECTION_NAME, name, new_config.get(name))


# Retrieves all keys from ConfigFile and sets them
# checked the corresponding properties of @paramref `new_config`
# @param new_config: PlayFabClientConfig - object to set properties checked
func _get_values(new_config: PlayFabClientConfig):
	var props = new_config.get_property_list()

	for i in range(3, props.size()):
		var name = props[i].name
		if _config.has_section_key(SECTION_NAME, name):
			var value = _config.get_value(SECTION_NAME, name)
			new_config.set(name, value)
