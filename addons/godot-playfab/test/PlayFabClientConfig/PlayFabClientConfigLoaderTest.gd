# GdUnit generated TestSuite
class_name PlayFabClientConfigLoaderTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/godot-playfab/PlayFabClientConfig/PlayFabClientConfigLoader.gd'


var path = "res://addons/godot-playfab/temp/test_playfab_client_config.cfg"

#func after_test():
#	var directory := DirAccess.open(path)
#	directory.remove(path)
	

# DISABLED - as it is broken in CI! See https://github.com/Structed/godot-playfab/issues/36
#func test_save_creates_config_file():
#	# Arrange
#	var config = PlayFabClientConfig.new()
#	var loader = PlayFabClientConfigLoader.new()
#	loader._load_path = path
#	loader.save("123", config)
#
#	# Act
#	var file_exists = FileAccess.file_exists(path)
#
#	# Assert
#	assert_bool(file_exists).is_true()


func test__set_value_sets_values():
	# Arrange
	var loader = PlayFabClientConfigLoader.new()
	loader._load_path = path

	var config = PlayFabClientConfig.new()
	var expected = PlayFabClientConfig.LoginType.LOGIN_CUSTOM_ID
	config.login_type = expected

	# Act
	loader._set_values(config)
	var actual = loader._config.get_value(PlayFabClientConfigLoader.SECTION_NAME, "login_type")

	# Assert
	assert_int(actual).is_equal(expected)


func test__get_values_gets_values():
	# Arrange
	var config = PlayFabClientConfig.new()
	var expected = "<ACCOUNT ID>"

	var loader = PlayFabClientConfigLoader.new()
	loader._load_path = path
	loader._config.set_value(PlayFabClientConfigLoader.SECTION_NAME, "master_player_account_id", expected)

	# Act
	loader._get_values(config)
	var actual = config.master_player_account_id	

	# Assert
	assert_str(actual).is_equal(expected)
