extends Node


const EVENT_NAME_TELEMETRY = "title_player_telemetry_event"
const EVENT_NAME_PLAYSTREAM = "title_player_playstream_event"

func _ready():
	var _error = PlayFabManager.client.connect("api_error",Callable(self,"_on_PlayFab_api_error"))
	_error = PlayFabManager.event.connect("api_error",Callable(self,"_on_PlayFab_api_error"))


func _on_BatchTelemetryEventsButton_pressed():
	var payload = {
		"Action": "_on_BatchTelemetryEventsButton_pressed"
	}

	PlayFabManager.event.batch_title_player_telemetry_event(EVENT_NAME_TELEMETRY, payload)


func _on_BatchPlayStreamEventsButton_pressed():
	var payload = {
		"Action": "_on_BatchPlayStreamEventsButton_pressed"
	}

	PlayFabManager.event.batch_title_player_playstream_event(EVENT_NAME_PLAYSTREAM, payload)


func _on_WriteTelemetryDirectButton_pressed():
	var payload = {
		"Action": "_on_WriteTelemetryDirectButton_pressed"
	}

	PlayFabManager.event.write_title_player_telemetry_event(EVENT_NAME_TELEMETRY, payload, Callable(self, "_on_write_events_request_completed"))


func _on_WritePlayStreamDirectButton_pressed():
	var payload = {
		"Action": "_on_WritePlayStreamDirectButton_pressed"
	}

	PlayFabManager.event.write_title_player_playstream_event(EVENT_NAME_PLAYSTREAM, payload, Callable(self, "_on_write_events_request_completed"))


func _on_write_events_request_completed(response):
	$VBoxContainer/Response.text = JSON.stringify(response.data, "\t")


func _on_PlayFab_api_error(error: ApiErrorWrapper):
	print_debug(error.errorMessage)


func _on_BackButton_pressed():
	SceneManager.goto_scene("res://Scenes/LoggedIn.tscn")


func _on_OpenPlayStreamButton_pressed():
	OS.shell_open("https://developer.playfab.com/en-us/" + PlayFabManager.title_id + "/dashboard/monitoring/playstream")
