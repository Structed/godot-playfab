extends Control

const STATISTIC_NAME = "time_waiting"
var row_item_node = preload("res://Scenes/Widgets/RowItem.tscn")
var start_time: int
var waiting = false
var version = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	start()
	var _error = PlayFabManager.client.connect("api_error", _on_PlayFab_api_error)

	# Add header row
	var _instance = row_item_node.instantiate()
	_instance.get_node("Rank").text = "Rank"
	_instance.get_node("Name").text = "PlayerName"
	_instance.get_node("Score").text = "Score"
	$Statistics/LeaderboardVBox.add_child(_instance)

	_show_progess()

	# Set version
	var request_data = GetPlayerStatisticVersionsRequest.new()
	request_data.StatisticName = STATISTIC_NAME
	PlayFabManager.client.get_player_statistic_version(request_data, _on_get_player_statistic_version)


func _process(_delta):
	if (waiting):
		$Statistics/LayoutHbox/ElapsedTimeLabel.text = str(get_elapsed_time())


func _on_StopWaitingButton_pressed():
	if (waiting):
		waiting = false
		$Statistics/StopWaitingButton.text = "Start waiting for Godot!"
		_update_statistic(get_elapsed_time())
	else:
		start()


func get_elapsed_time() -> int:
	return Time.get_unix_time_from_system() - start_time


func start():
	start_time = Time.get_unix_time_from_system()
	waiting = true
	$Statistics/StopWaitingButton.text = "Stop waiting for Godot!"


func _update_statistic(value: int):
	var statistic = StatisticUpdate.new()
	statistic.StatisticName = STATISTIC_NAME
	statistic.Value = value
	statistic.Version = version
	# API sends data in the context of the player, so PlayFab know which player sent the request!
	PlayFabManager.client.update_player_statistic(statistic, _on_update_statistics_request_completed)


func get_leaderboard():
	var request_data = GetLeaderboardRequest.new()
	request_data.StatisticName = STATISTIC_NAME
	request_data.Version = version
	request_data.MaxResultsCount = 10
	request_data.UseSpecificVersion = true

	PlayFabManager.client.get_leaderboard(request_data, _on_get_leaderboard_request_completed)

func _add_statistic_row(data: PlayerLeaderboardEntry):
		var _instance = row_item_node.instantiate()
		_instance.get_node("Rank").text = str(data.Position + 1)
		_instance.get_node("Name").text = data.DisplayName
		_instance.get_node("Score").text = str(data.StatValue)
		$Statistics/LeaderboardVBox.add_child(_instance)

func _on_get_leaderboard_request_completed(result):
	var leaderboard_result = GetLeaderboardResult.new()
	leaderboard_result.from_dict(result["data"], leaderboard_result)

	for row in leaderboard_result.Leaderboard._Items:
		_add_statistic_row(row)

	_hide_progess()

func _on_update_statistics_request_completed(_result):
	print_debug("Completed sending stats")

func _on_PlayFab_api_error(error: ApiErrorWrapper):
	print_debug(error.errorMessage)

func _on_BackButton_pressed():
	SceneManager.goto_scene("res://Scenes/LoggedIn.tscn")


func _on_get_player_statistic_version(result):
	var get_player_statistic_versions_result = GetPlayerStatisticVersionsResult.new()
	get_player_statistic_versions_result.from_dict(result["data"], get_player_statistic_versions_result)
	version = get_player_statistic_versions_result.StatisticVersions.get_latest_version()
	$Statistics/LeaderboardVBox/VersionHBox/LeaderboardVersion.text = str(version)

	get_leaderboard()


func _on_GetPlayerStatisticsButton_pressed():
	var request_data = GetPlayerStatisticsRequest.new()
	#request_data.StatisticNames = [ STATISTIC_NAME ]

	PlayFabManager.client.get_player_statistics(request_data, _on_get_player_statistics_request_completed)


func _on_get_player_statistics_request_completed(result):
	var get_player_statistics_result = GetPlayerStatisticsResult.new()
	get_player_statistics_result.from_dict(result["data"], get_player_statistics_result)



func _show_progess():
	$Statistics.hide()
	$ProgressCenter/LoginIndicator.show()

func _hide_progess():
	$ProgressCenter/LoginIndicator.hide()
	$Statistics.show()
