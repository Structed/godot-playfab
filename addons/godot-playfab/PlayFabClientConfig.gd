extends Reference
class_name PlayFabClientConfig, "res://addons/godot-playfab/icon.png"


const DEBUG_DO_NOT_ENCRYPT = false	# Only works on debug builds
const CONFIG_LOAD_PATH = "user://playfab_client_config.cfg"
const SECTION_NAME = "PlayFab"

var _config: ConfigFile

var password
var title_id setget set_title_id
var base_uri = "playfabapi.com"
var api_url

## The Client Session ticket. Used for /Client API
var session_ticket = "" setget set_session_ticket,get_session_ticket

## The Master Player Account ID, aka "PlayFab ID"
var master_player_account_id setget set_master_player_account_id,get_master_player_account_id

## Object holding the Entity Token, as well as the EntityKey (ID, Type) of the logged in Entity (usually title_player_account)
var entity_token : EntityTokenResponse setget set_entity_token,get_entity_token


var initialized = false
var login_type = LoginType.LOGIN_NONE

## User Identifier - Email, UUID etc. This is dependent on the Login Type
## LOGIN_EMAIL - Email
## LOGIN_CUSTOM_ID - UUID
var login_id = "" setget set_login_id


enum LoginType {
	LOGIN_NONE,
	LOGIN_EMAIL,
	LOGIN_CUSTOM_ID
}


func _init(title_id: String):
	password = title_id
	set_title_id(title_id)
	_load_config()


func set_title_id(value: String):
	title_id = value
	api_url = "https://%s.%s" % [ title_id, base_uri ]


func set_session_ticket(value: String):
	session_ticket = value
	_save_config()


func get_session_ticket() -> String:
	return session_ticket


func set_master_player_account_id(id: String):
	master_player_account_id = id
	_save_config()


func get_master_player_account_id() -> String:
	return master_player_account_id


func set_entity_token(token: EntityTokenResponse):
	entity_token = token
	_save_config()


func get_entity_token() -> EntityTokenResponse:
	return entity_token


func set_login_id(value):
	login_id = value


func set_login_type(value):
	login_type = value


func is_logged_in() -> bool:
	if !initialized:
		_load_config()
	return !session_ticket.empty()


func _save_config():
	_config.set_value(SECTION_NAME, "session_ticket", session_ticket)
	_config.set_value(SECTION_NAME, "master_player_account_id", master_player_account_id)
	_config.set_value(SECTION_NAME, "entity_token", entity_token)
	_config.set_value(SECTION_NAME, "login_id", login_id)
	_config.set_value(SECTION_NAME, "login_type", login_type)

	if OS.is_debug_build() && DEBUG_DO_NOT_ENCRYPT:
		_config.save(CONFIG_LOAD_PATH)
	else:
		_config.save_encrypted_pass(CONFIG_LOAD_PATH, password)


func _load_config():
	_config = ConfigFile.new()
	var err: int
	if OS.is_debug_build() && DEBUG_DO_NOT_ENCRYPT:
		err = _config.load(CONFIG_LOAD_PATH)
	else:
		err = _config.load_encrypted_pass(CONFIG_LOAD_PATH, password)

	# If the file didn't load, ignore it.
	if err != OK:
		print_debug("Config file didn't load. Error code: %f" % err)
		return

	initialized = true
	session_ticket = _config.get_value(SECTION_NAME, "session_ticket")
	master_player_account_id = _config.get_value(SECTION_NAME, "master_player_account_id")
	entity_token = _config.get_value(SECTION_NAME, "entity_token")
	login_id = _config.get_value(SECTION_NAME, "login_id")
	login_type = _config.get_value(SECTION_NAME, "login_type")
