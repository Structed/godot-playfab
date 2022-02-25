extends MarginContainer

func _on_Login_pressed():
	$Login.hide()
	$TextureProgress.show()
	
	var email = $Login/Email/Input.text
	var password = $Login/Password/Input.text
	
	var combined_info_request_params = GetPlayerCombinedInfoRequestParams.new()
	combined_info_request_params.show_all()
	var player_profile_view_constraints = PlayerProfileViewConstraints.new()
	combined_info_request_params.ProfileConstraints = player_profile_view_constraints
	var tags = {}
	Global.play_fab.login_with_email(email, password, tags, combined_info_request_params)
	
	if not Global.play_fab.is_connected("logged_in", self, "_on_logged_in"):
		Global.play_fab.connect("logged_in", self, "_on_logged_in", [], CONNECT_ONESHOT)
		
	if not Global.play_fab.is_connected("api_error", self, "_on_api_error"):
		Global.play_fab.connect("api_error", self, "_on_api_error", [], CONNECT_ONESHOT)

func _on_logged_in(login_result: LoginResult):
	$Login/Login.self_modulate = Color(0, 1, 0, 0.5)
	$Login/Output.hide()
	$TextureProgress.hide()

	$LoggedIn.login_result = login_result
	$LoggedIn.update()
	$LoggedIn.show()
	
func _on_api_error(api_error_wrapper: ApiErrorWrapper):
	var text = "[b]%s[/b]\n\n" % api_error_wrapper.errorMessage
	var error_details = api_error_wrapper.errorDetails
	
	if error_details:
		for key in error_details.keys():
			text += "[color=red][b]%s[/b][/color]: " % key 
			for element in error_details[key]:
				text += "%s\n" % element
			
	$Login/Login.self_modulate = Color(1, 0, 0, 0.5)
	$Login/Output.show()
	$Login/Output.bbcode_text = text	


func _on_Back_pressed():
	SceneManager.goto_scene("res://Scenes/Main.tscn")

func _process(delta):
	if $TextureProgress.visible:
		if $TextureProgress.value >= $TextureProgress.max_value:
			$TextureProgress.value = 0
			
		print_debug("Texture progress increment: %f" % $TextureProgress.value)
		$TextureProgress.value += 1

func _on_LoggedInBackButton_pressed():
	$LoggedIn.hide()
	$Login.show()
	pass
