@icon("res://addons/godot-playfab/icon.png")

extends RefCounted
class_name PlayFabClientConfig

# Timeout for the sesion token
const TOKEN_TIMEOUT = 23 * 3600

## The Client Session ticket. Used for /Client API
var session_ticket: String : set = _set_session_ticket

## The Master Player Account ID, aka "PlayFab ID"
var master_player_account_id: String

## Object holding the Entity Token, as well as the EntityKey (ID, Type) of the logged in Entity (usually title_player_account)
var entity_token: EntityTokenResponse = EntityTokenResponse.new()

# One of `LoginType`. Denotes the authentication method used for the login saved here
var login_type = LoginType.LOGIN_NONE

## User Identifier - Email, UUID etc. This is dependent checked the Login Type
## LOGIN_EMAIL - Email
## LOGIN_CUSTOM_ID - UUID
var login_id = ""

# Last Login timestamp - when tokens were refreshed
var login_timestamp = 0

enum LoginType { LOGIN_NONE, LOGIN_EMAIL, LOGIN_CUSTOM_ID }

# Whether the user should stay logged in
var stay_logged_in = false


# Checks whether the account is considered logged in
func is_logged_in() -> bool:
	if session_ticket.is_empty() || is_login_token_expired():
		return false

	return true


# Validates whether the login token has expired (based checked time)
func is_login_token_expired() -> bool:
	var elapsed_time = Time.get_unix_time_from_system() - login_timestamp

	if elapsed_time < 0 || elapsed_time > TOKEN_TIMEOUT:
		return true

	return false


# Sets the session_ticket and updates the login_timestamp
func _set_session_ticket(value: String):
	login_timestamp = Time.get_unix_time_from_system()
	session_ticket = value
