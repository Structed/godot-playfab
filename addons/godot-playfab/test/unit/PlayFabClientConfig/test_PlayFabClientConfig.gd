extends "res://addons/gut/test.gd"

var config: PlayFabClientConfig


func before_each():
	config = PlayFabClientConfig.new()


# is_logged_in() Tests


func test_is_logged_in_returns_true_if_session_ticket_exists():
	# Arrange
	config.session_ticket = "<SESSION_TICKET>"

	# Act
	var is_logged_in = config.is_logged_in()

	# Assert
	assert_true(is_logged_in)


func test_is_logged_in_returns_false_if_session_ticket_is_empty():
	# Arrange
	config.session_ticket = ""

	# Act
	var is_logged_in = config.is_logged_in()

	# Assert
	assert_false(is_logged_in)


func test_is_logged_in_returns_false_if_login_token_expired_returns_true():
	# Arrange
	config.session_ticket = "<SESSION_TICKET>"
	config.login_timestamp = -1

	# Act
	var is_logged_in = config.is_logged_in()

	# Assert
	assert_false(is_logged_in)


func test_is_logged_in_returns_true_if_login_token_expired_returns_false():
	# Arrange
	config.session_ticket = "<SESSION_TICKET>"

	# Act
	var is_logged_in = config.is_logged_in()

	# Assert
	assert_true(is_logged_in)


## is_login_token_expired() Tests


func test_is_login_token_expired_returns_false_if_token_within_threshold():
	# Arrange
	config.login_timestamp = OS.get_unix_time() - 60

	# Act
	var is_expired = config.is_login_token_expired()

	# Assert
	assert_false(is_expired)


func test_is_login_token_expired_returns_true_if_above_threshold():
	# Arrange
	config.login_timestamp = OS.get_unix_time() + PlayFabClientConfig.TOKEN_TIMEOUT + 1

	# Act
	var is_expired = config.is_login_token_expired()

	# Assert
	assert_true(is_expired)


func test_is_login_token_expired_returns_true_if_negative():
	# Arrange
	config.login_timestamp = -1

	# Act
	var is_expired = config.is_login_token_expired()

	# Assert
	assert_true(is_expired)


# _set_session_ticket() Tests


func test__set_session_ticket_updates_login_timestamp():
	# Arrange / Act
	config.session_ticket = "<SESSION TICKET>"

	var expected = OS.get_unix_time()
	var actual = config.login_timestamp

	# Assert
	assert_almost_eq(actual, expected, 1)
