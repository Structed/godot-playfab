extends Control
class_name LoggedIn

var login_result: LoginResult


# Called when the node enters the scene tree for the first time.
func update():
	$VBoxContainer/AccountPlayerId/Edit.text = login_result.PlayFabId
	$VBoxContainer/TitlePlayerId/Edit.text = login_result.InfoResultPayload.AccountInfo.TitleInfo.TitlePlayerAccount.Id
	$VBoxContainer/TitlePlayerName/Edit.text = login_result.InfoResultPayload.AccountInfo.TitleInfo.DisplayName
	$VBoxContainer/SessionTicket/Edit.text = login_result.SessionTicket
	$VBoxContainer/EntityToken/Edit.text = login_result.EntityToken.EntityToken
	$VBoxContainer/EntityType/Edit.text = login_result.EntityToken.Entity.Type
	$VBoxContainer/EntityId/Edit.text = login_result.EntityToken.Entity.Id


func _on_Button_pressed():
	var request_data = GetTitleDataRequest.new()
#	request_data.Keys.append("BarKey")	# Would only get the key "BarKey"
	$PlayFabClient.get_title_data(request_data, funcref(self, "_on_get_title_data"))


func _on_get_title_data(response):
	$VBoxContainer/Response.text = JSON.print(response.data, "\t")


const EVENT_NAME_TELEMETRY = "title_player_telemetry_event"
const EVENT_NAME_PLAYSTREAM = "title_player_playstream_event"

func _on_BatchTelemetryEventsButton_pressed():
	var payload = {
		"Action": "_on_BatchTelemetryEventsButton_pressed"
	}

	$PlayFabEvent.batch_title_player_telemetry_event(EVENT_NAME_TELEMETRY, payload, funcref(self, "_on_write_events_request_completed"))


func _on_BatchPlayStreamEventsButton_pressed():
	var payload = {
		"Action": "_on_BatchPlayStreamEventsButton_pressed"
	}

	$PlayFabEvent.batch_title_player_playstream_event(EVENT_NAME_PLAYSTREAM, payload, funcref(self, "_on_write_events_request_completed"))


func _on_write_events_request_completed(response):
	$VBoxContainer/Response.text = JSON.print(response.data, "\t")


func _on_WriteTelemetryDirectButton_pressed():
	var payload = {
		"Action": "_on_WriteTelemetryDirectButton_pressed"
	}

	$PlayFabEvent.write_title_player_telemetry_event(EVENT_NAME_TELEMETRY, payload, funcref(self, "_on_write_events_request_completed"))


func _on_WritePlayStreamDirectButton_pressed():
	var payload = {
		"Action": "_on_WritePlayStreamDirectButton_pressed"
	}

	$PlayFabEvent.write_title_player_playstream_event(EVENT_NAME_PLAYSTREAM, payload, funcref(self, "_on_write_events_request_completed"))


func _on_PlayFab_api_error(error: ApiErrorWrapper):
	print_debug(error.errorMessage)
