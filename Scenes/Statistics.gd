extends VBoxContainer

var start_time: int
var waiting = false


# Called when the node enters the scene tree for the first time.
func _ready():
	start()
	var _error = PlayFabManager.client.connect("api_error", self, "_on_PlayFab_api_error")


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
	var request_data = UpdatePlayerStatisticsRequest.new()
	var statistic = StatisticUpdate.new()

	statistic.StatisticName = "time_waiting"
	statistic.Value = value
	statistic.Version = 1	# Make sure to imncrement this for updates where rules changes the scores

	request_data.Statistics = StatisticUpdateCollection.new()
	request_data.Statistics.append(statistic)
	PlayFabManager.client.update_player_statistic(request_data, funcref(self, "_on_update_statistics_request_completed"))

func _on_update_statistics_request_completed(_result):
	print_debug("Completed sending stats")


func _on_PlayFab_api_error(error: ApiErrorWrapper):
	print_debug(error.errorMessage)