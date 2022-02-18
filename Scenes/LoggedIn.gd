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
