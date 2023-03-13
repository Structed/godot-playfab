# GdUnit generated TestSuite
class_name PlayFabClientConfigTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/godot-playfab/PlayFabClientConfig/PlayFabClientConfig.gd'


var config: PlayFabClientConfig

func before_test():
	config = PlayFabClientConfig.new()



func test_is_logged_in_returns_true_if_session_ticket_exists():
	# Arrange
	config.session_ticket = "<SESSION_TICKET>"

	# Act
	var is_logged_in = config.is_logged_in()

	# Assert
	assert_bool(is_logged_in).is_true()


func test_is_logged_in_returns_false_if_session_ticket_is_empty():
	# Arrange
	config.session_ticket = ""

	# Act
	var is_logged_in = config.is_logged_in()

	# Assert
	assert_bool(is_logged_in).is_false()


func test_is_logged_in_returns_false_if_login_token_expired_returns_true():
	# Arrange
	config.session_ticket = "<SESSION_TICKET>"
	config.login_timestamp = -1

	# Act
	var is_logged_in = config.is_logged_in()

	# Assert
	assert_bool(is_logged_in).is_false()


func test_is_logged_in_returns_true_if_login_token_expired_returns_false():
	# Arrange
	config.session_ticket = "<SESSION_TICKET>"

	# Act
	var is_logged_in = config.is_logged_in()

	# Assert
	assert_bool(is_logged_in).is_true()


# is_login_token_expired() Tests

func test_is_login_token_expired_returns_false_if_token_within_threshold():
	# Arrange
	config.login_timestamp = Time.get_unix_time_from_system() - 60

	# Act
	var is_expired = config.is_login_token_expired()

	# Assert
	assert_bool(is_expired).is_false()


func test_is_login_token_expired_returns_true_if_above_threshold():
	# Arrange
	config.login_timestamp = Time.get_unix_time_from_system() + PlayFabClientConfig.TOKEN_TIMEOUT + 1

	# Act
	var is_expired = config.is_login_token_expired()

	# Assert
	assert_bool(is_expired).is_true()


func test_is_login_token_expired_returns_true_if_negative():
	# Arrange
	config.login_timestamp = -1

	# Act
	var is_expired = config.is_login_token_expired()

	# Assert
	assert_bool(is_expired).is_true()


# _set_session_ticket() Tests

func test__set_session_ticket_updates_login_timestamp():
	# Arrange / Act
	config.session_ticket = "<SESSION TICKET>"

	var expected = Time.get_unix_time_from_system()
	var actual = config.login_timestamp

	# Assert
	assert_float(actual).is_between(expected - 1, expected + 1)
