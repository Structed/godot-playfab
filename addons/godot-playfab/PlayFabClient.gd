extends PlayFab
class_name PlayFabClient, "res://addons/godot-playfab/icon.png"

# Retrieves the key-value store of custom title settings
# @param request_data: GetTitleDataRequest
# @param callback: FuncRef
func get_title_data(request_data: GetTitleDataRequest, callback: FuncRef):
	_post_with_session_auth(request_data, "/Client/GetTitleData", callback)


func update_player_statistic(request_data: UpdatePlayerStatisticsRequest, callback: FuncRef):
	_post_with_session_auth(request_data, "/Client/UpdatePlayerStatistics", callback)