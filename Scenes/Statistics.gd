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
	var statistic = StatisticUpdate.new()
	statistic.StatisticName = "time_waiting"
	statistic.Value = value
	statistic.Version = 1
	PlayFabManager.client.update_player_statistic(statistic, funcref(self, "_on_update_statistics_request_completed"))

func _on_update_statistics_request_completed(_result):
	print_debug("Completed sending stats")


func _on_PlayFab_api_error(error: ApiErrorWrapper):
	print_debug(error.errorMessage)

func _on_BackButton_pressed():
	SceneManager.goto_scene("res://Scenes/LoggedIn.tscn")
