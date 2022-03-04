extends MarginContainer

func _on_Login_pressed():
	$Login.hide()
	_show_progess()
	
	var email = $Login/Email/Input.text
	var password = $Login/Password/Input.text
	
	var combined_info_request_params = GetPlayerCombinedInfoRequestParams.new()
	combined_info_request_params.show_all()
	var player_profile_view_constraints = PlayerProfileViewConstraints.new()
	combined_info_request_params.ProfileConstraints = player_profile_view_constraints
	var tags = {}
	$PlayFab.login_with_email(email, password, tags, combined_info_request_params)


func _on_AnonLogin_pressed():
	$Login.hide()
	_show_progess()
	var combined_info_request_params = GetPlayerCombinedInfoRequestParams.new()
	combined_info_request_params.show_all()
	var player_profile_view_constraints = PlayerProfileViewConstraints.new()
	combined_info_request_params.ProfileConstraints = player_profile_view_constraints
	
	$PlayFab.login_with_custom_id(UUID.v4(), true, combined_info_request_params)
	

func _show_progess():
	$ProgressCenter/TextureProgress.value = 0
	$ProgressCenter.show()
	
func _hide_progess():
	$ProgressCenter.hide()
	

func _on_logged_in(login_result: LoginResult):
	$Login/Login.self_modulate = Color(0, 1, 0, 0.5)
	$Login/Output.hide()
	_hide_progess()

	$LoggedIn.login_result = login_result
	$LoggedIn.update()
	$LoggedIn.show()
	
func _on_api_error(api_error_wrapper: ApiErrorWrapper):
	_hide_progess()
	$Login.show()
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

func _process(_delta):
	if $ProgressCenter.visible:
		if $ProgressCenter/TextureProgress.value >= $ProgressCenter/TextureProgress.max_value:
			$ProgressCenter/TextureProgress.value = 0
			
		$ProgressCenter/TextureProgress.value += 1

func _on_LoggedInBackButton_pressed():
	$LoggedIn.hide()
	$Login.show()
	pass
