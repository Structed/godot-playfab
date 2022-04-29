extends Control
class_name LoggedIn

var login_result: LoginResult


func _ready():
	var _error = PlayFabManager.client.connect("api_error", self, "_on_PlayFab_api_error")


# Called when the node enters the scene tree for the first time.
func update():
	if login_result != null:
		$VBoxContainer/LoginResultContainer/AccountPlayerId/Edit.text = login_result.PlayFabId
		$VBoxContainer/LoginResultContainer/TitlePlayerId/Edit.text = login_result.InfoResultPayload.AccountInfo.TitleInfo.TitlePlayerAccount.Id
		$VBoxContainer/LoginResultContainer/TitlePlayerName/Edit.text = login_result.InfoResultPayload.AccountInfo.TitleInfo.DisplayName
		$VBoxContainer/LoginResultContainer/SessionTicket/Edit.text = login_result.SessionTicket
		$VBoxContainer/LoginResultContainer/EntityToken/Edit.text = login_result.EntityToken.EntityToken
		$VBoxContainer/LoginResultContainer/EntityType/Edit.text = login_result.EntityToken.Entity.Type
		$VBoxContainer/LoginResultContainer/EntityId/Edit.text = login_result.EntityToken.Entity.Id

		$VBoxContainer/LoginResultContainer.show()


func _on_Button_pressed():
	var request_data = GetTitleDataRequest.new()
#	request_data.Keys.append("BarKey")	# Would only get the key "BarKey"
	PlayFabManager.client.get_title_data(request_data, funcref(self, "_on_get_title_data"))


func _on_get_title_data(response):
	$VBoxContainer/Response.text = JSON.print(response.data, "\t")


func _on_PlayFab_api_error(error: ApiErrorWrapper):
	print_debug(error.errorMessage)


func _on_EventsPlayStream_pressed():
	SceneManager.goto_scene("res://Scenes/Events.tscn")
