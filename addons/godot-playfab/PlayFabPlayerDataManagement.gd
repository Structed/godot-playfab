extends PlayFab
class_name PlayFabPlayerDataManagement, "res://addons/godot-playfab/icon.png"


# Retrieves the indicated statistics (current version and values for all statistics, if none are specified), for the local player.
#
# REST API Docs: https://docs.microsoft.com/en-us/rest/api/playfab/client/player-data-management/get-player-statistics?view=playfab-rest
# Service: Client
# API Version: 220704
#
# @param request_data: GetPlayerStatisticVersionsRequest
# @param callback: FuncRef
func get_player_statistics(request_data: GetPlayerStatisticsRequest, callback: FuncRef):
	_post_with_session_auth(request_data, "/Client/GetPlayerStatistics", callback)