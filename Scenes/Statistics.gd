extends VBoxContainer

const STATISTIC_NAME = "time_waiting"
const STATISTIC_VERSION = 10
var row_item_node = preload("res://Scenes/Widgets/RowItem.tscn")
var start_time: int
var waiting = false


# Called when the node enters the scene tree for the first time.
func _ready():
	start()
	var _error = PlayFabManager.client.connect("api_error", self, "_on_PlayFab_api_error")
	get_leaderboard()


func _process(_delta):
	if (waiting):
		$LayoutHbox/ElapsedTimeLabel.text = str(get_elapsed_time())


func _on_StopWaitingButton_pressed():
	if (waiting):
		waiting = false
		$StopWaitingButton.text = "Start waiting for Godot!"
		_update_statistic(get_elapsed_time())
	else:
		start()


func get_elapsed_time() -> int:
	return OS.get_unix_time() - start_time


func start():
	start_time = OS.get_unix_time()
	waiting = true
	$StopWaitingButton.text = "Stop waiting for Godot!"


func _update_statistic(value: int):
	var statistic = StatisticUpdate.new()
	statistic.StatisticName = STATISTIC_NAME
	statistic.Value = value
	statistic.Version = STATISTIC_VERSION
	PlayFabManager.client.update_player_statistic(statistic, funcref(self, "_on_update_statistics_request_completed"))


func get_leaderboard():
	var request_data = GetLeaderboardRequest.new()
	request_data.StatisticName = STATISTIC_NAME
	request_data.Version = STATISTIC_VERSION
	request_data.MaxResultsCount = 10
	request_data.UseSpecificVersion = true

	PlayFabManager.client.get_leaderboard(request_data, funcref(self, "_on_get_leaderboard_request_completed"))

func _add_statistic_row(data: PlayerLeaderboardEntry):
		var _instance = row_item_node.instance()
		_instance.get_node("Rank").text = str(data.Position)
		_instance.get_node("Name").text = data.DisplayName
		_instance.get_node("Score").text = str(data.StatValue)
		$LeaderboardVBox.add_child(_instance)

func _on_get_leaderboard_request_completed(result):
	var leaderboard_result = GetLeaderboardResult.new()
	leaderboard_result.from_dict(result["data"], leaderboard_result)

	for row in leaderboard_result.Leaderboard._Items:
		_add_statistic_row(row)

func _on_update_statistics_request_completed(_result):
	print_debug("Completed sending stats")

func _on_PlayFab_api_error(error: ApiErrorWrapper):
	print_debug(error.errorMessage)

func _on_BackButton_pressed():
	SceneManager.goto_scene("res://Scenes/LoggedIn.tscn")



