extends VBoxContainer


func _on_Login_pressed():
	var email = $Email/Input.text
	var password = $Password/Input.text
	Global.play_fab.login_with_email(email, password, null, null)
	
	if not Global.play_fab.is_connected("logged_in", self, "_on_logged_in"):
		Global.play_fab.connect("logged_in", self, "_on_logged_in", [], CONNECT_ONESHOT)
		
	if not Global.play_fab.is_connected("api_error", self, "_on_api_error"):
		Global.play_fab.connect("api_error", self, "_on_api_error", [], CONNECT_ONESHOT)

func _on_logged_in(login_result: LoginResult):
	$Login.self_modulate = Color(0, 1, 0, 0.5)
	$Output.bbcode_text = "Player with \"%s\" logged in successfully!" % login_result.PlayFabId
	
func _on_api_error(api_error_wrapper: ApiErrorWrapper):
	var text = "[b]%s[/b]\n\n" % api_error_wrapper.errorMessage
	var error_details = api_error_wrapper.errorDetails
	
	if error_details:
		for key in error_details.keys():
			text += "[color=red][b]%s[/b][/color]: " % key 
			for element in error_details[key]:
				text += "%s\n" % element
			
	$Login.self_modulate = Color(1, 0, 0, 0.5)
	$Output.bbcode_text = text	


func _on_Back_pressed():
	SceneManager.goto_scene("res://Scenes/Main.tscn")
