extends Control
class_name LoggedIn

var login_result: LoginResult


func _ready():
	var _error = PlayFabManager.client.connect("api_error", self, "_on_PlayFab_api_error")


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
	PlayFabManager.client.get_title_data(request_data, funcref(self, "_on_get_title_data"))


func _on_get_title_data(response):
	$VBoxContainer/Response.text = JSON.print(response.data, "\t")


func _on_PlayFab_api_error(error: ApiErrorWrapper):
	print_debug(error.errorMessage)


func _on_EventsPlayStream_pressed():
	SceneManager.goto_scene("res://Scenes/Events.tscn")
