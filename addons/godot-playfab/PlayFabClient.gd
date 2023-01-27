@icon("res://addons/godot-playfab/icon.png")

extends PlayFab
class_name PlayFabClient

func _ready():
	super._ready()

# Retrieves the key-value store of custom title settings
# @param request_data: GetTitleDataRequest
# @param callback: Callable
func get_title_data(request_data: GetTitleDataRequest, callback: Callable):
	_post_with_session_auth(request_data, "/Client/GetTitleData", callback)
