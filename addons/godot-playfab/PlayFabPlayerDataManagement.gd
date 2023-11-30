@icon("res://addons/godot-playfab/icon.png")

extends PlayFab
class_name PlayFabPlayerDataManagement


# Retrieves the indicated statistics (current version and values for all statistics, if none are specified), for the local player.
#
# REST API Docs: https://docs.microsoft.com/en-us/rest/api/playfab/client/player-data-management/get-player-statistics?view=playfab-rest
# Service: Client
# API Version: 220704
#
# @param request_data: GetPlayerStatisticVersionsRequest
# @param callback: Callable
func get_player_statistics(request_data: GetPlayerStatisticsRequest, callback: Callable):
	_post_with_session_auth(request_data, "/Client/GetPlayerStatistics", callback)
