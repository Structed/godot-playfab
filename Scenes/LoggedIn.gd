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
	Global.play_fab._session_ticket = login_result.SessionTicket


func _on_Button_pressed():
	var response = Global.play_fab.get_title_data([], funcref(self, "_on_get_title_data"))
	

func _on_get_title_data(response):
	$VBoxContainer/Response.text = JSON.print(response.data, "\t")
