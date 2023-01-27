extends Control
class_name LoggedIn

var login_result: LoginResult
signal logout


func _ready():
	var _error = PlayFabManager.client.connect("api_error", func(error: ApiErrorWrapper):
		print_debug(error.errorMessage)
	)


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


func _on_GetTitleDataButton_pressed():
	var request_data = GetTitleDataRequest.new()
#	request_data.Keys.append("BarKey")	# Would only get the key "BarKey"
	PlayFabManager.client.get_title_data(request_data, func(response):
		$VBoxContainer/Response.text = JSON.stringify(response.data, "\t")
	)


func _on_EventsPlayStream_pressed():
	SceneManager.goto_scene("res://Scenes/Events.tscn")


func _on_RequestBuilder_pressed():
	SceneManager.goto_scene("res://Scenes/RequestBuilder.tscn")


func _on_MainMenuButton_pressed():
	SceneManager.goto_scene("res://Scenes/Main.tscn")


func _on_LogoutButton_pressed():
	emit_signal("logout")
