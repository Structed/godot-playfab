extends Resource
class_name PlayFabConfig, "res://addons/godot-playfab/icon.png"


const CONFIG_LOAD_PATH = "user://playfab_config.tres"


export(String) var title_id setget set_title_id
export(String) var base_uri = "playfabapi.com"
export(String) var api_url
export(String) var session_ticket = "" setget set_session_ticket,get_session_ticket


func set_title_id(value: String):
	api_url = "https://%s.%s" % [ value, base_uri ]


func set_session_ticket(value: String):
	session_ticket = value
	

func get_session_ticket() -> String:
	return session_ticket


func is_logged_in() -> bool:
	return !session_ticket.empty()


func is_not_logged_in() -> bool:
	return session_ticket.empty()
