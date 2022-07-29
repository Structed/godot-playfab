extends PlayFab
class_name PlayFabClient, "res://addons/godot-playfab/icon.png"

# Retrieves the key-value store of custom title settings
# @param request_data: GetTitleDataRequest
# @param callback: FuncRef
func get_title_data(request_data: GetTitleDataRequest, callback: FuncRef):
	_post_with_session_auth(request_data, "/Client/GetTitleData", callback)


# Updates the value of one specific title-specific statistic for the user.
# By default, clients are not permitted to update statistics.
# Developers may override this setting in the Game Manager > Settings > API Features.
# REST API Docs: https://docs.microsoft.com/en-us/rest/api/playfab/client/player-data-management/update-player-statistics?view=playfab-rest
# @param request_data: StatisticUpdate
# @param callback: FuncRef
func update_player_statistic(statistic: StatisticUpdate, callback: FuncRef):
	var request_data = UpdatePlayerStatisticsRequest.new()
	request_data.Statistics = StatisticUpdateCollection.new()
	request_data.Statistics.append(statistic)

	update_player_statistics(request_data, callback)


# Updates the values of the specified title-specific statistics for the user.
# By default, clients are not permitted to update statistics.
# Developers may override this setting in the Game Manager > Settings > API Features.
# REST API Docs: https://docs.microsoft.com/en-us/rest/api/playfab/client/player-data-management/update-player-statistics?view=playfab-rest
# @param request_data: UpdatePlayerStatisticsRequest
# @param callback: FuncRef
func update_player_statistics(request_data: UpdatePlayerStatisticsRequest, callback: FuncRef):
	_post_with_session_auth(request_data, "/Client/UpdatePlayerStatistics", callback)


# Retrieves a list of ranked users for the given statistic, starting from the indicated point in the leaderboard
# REST API Docs: https://docs.microsoft.com/en-us/rest/api/playfab/client/player-data-management/get-leaderboard?view=playfab-rest
# @param request_data: GetLeaderboardRequest
# @param callback: FuncRef
func get_leaderboard(request_data: GetLeaderboardRequest, callback: FuncRef):
	_post_with_session_auth(request_data, "/Client/GetLeaderboard", callback)


# Retrieves the information on the available versions of the specified statistic.
# REST API Docs: https://docs.microsoft.com/en-us/rest/api/playfab/client/player-data-management/get-player-statistic-versions?view=playfab-rest
# @param request_data: GetPlayerStatisticVersionsRequest
# @param callback: FuncRef
func get_player_statistic_version(request_data: GetPlayerStatisticVersionsRequest, callback: FuncRef):
	_post_with_session_auth(request_data, "/Client/GetPlayerStatisticVersions", callback)


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