extends Node
class_name PlayFabClientConfig, "res://addons/godot-playfab/icon.png"


const CONFIG_LOAD_PATH = "user://playfab_config.cfg"
const SECTION_NAME = "PlayFab"

var _config: ConfigFile

var password
var title_id setget set_title_id
var base_uri = "playfabapi.com"
var api_url
var session_ticket = "" setget set_session_ticket,get_session_ticket
var initialized = false

func _init(title_id: String):
	password = title_id
	set_title_id(title_id)
	_load_config()

func _process(_delta):
	if !initialized:
		_load_config()


func set_title_id(value: String):
	title_id = value
	api_url = "https://%s.%s" % [ title_id, base_uri ]


func set_session_ticket(value: String):
	session_ticket = value
	_config.set_value(SECTION_NAME, "session_ticket", session_ticket)
	_save_config()


func get_session_ticket() -> String:
	return session_ticket


func is_logged_in() -> bool:
	return !session_ticket.empty()


func is_not_logged_in() -> bool:
	return session_ticket.empty()


func _save_config():
	_config.save_encrypted_pass(CONFIG_LOAD_PATH, password)


func _load_config():
	_config = ConfigFile.new()
	var err = _config.load_encrypted_pass(CONFIG_LOAD_PATH, password)
	
	# If the file didn't load, ignore it.
	if err != OK:
		print_debug("Config file didn't load. Error code: %f" % err)
		return
		
	initialized = true
	session_ticket = _config.get_value(SECTION_NAME, "session_ticket")
