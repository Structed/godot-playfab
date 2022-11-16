extends MarginContainer

const color_green = Color(0, 1, 0, 0.5)
const color_white = Color(1, 1, 1, 1)
const color_red = Color(1, 0, 0, 0.5)

func _ready():
	var _error = PlayFabManager.client.connect("api_error", self, "_on_api_error")
	_error = PlayFabManager.client.connect("logged_in", self, "_on_logged_in")
	update_login_button_states()


func update_login_button_states():
	# Reset button colours
	$Login/Login.self_modulate = color_white
	$Login/AnonLogin.self_modulate = color_white

	if PlayFabManager.client_config.is_logged_in():
		match PlayFabManager.client_config.login_type:
			PlayFabClientConfig.LoginType.LOGIN_CUSTOM_ID:
				$Login/AnonLogin.self_modulate = color_green
			PlayFabClientConfig.LoginType.LOGIN_EMAIL:
				$Login/Login.self_modulate = color_green
			_:
				pass # No specific action needed


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
	PlayFabManager.client.login_with_email(email, password, tags, combined_info_request_params)


func _on_AnonLogin_pressed():
	$Login.hide()
	_show_progess()
	var combined_info_request_params = GetPlayerCombinedInfoRequestParams.new()
	combined_info_request_params.show_all()
	var player_profile_view_constraints = PlayerProfileViewConstraints.new()
	combined_info_request_params.ProfileConstraints = player_profile_view_constraints

	if PlayFabManager.client_config.login_type == PlayFabClientConfig.LoginType.LOGIN_CUSTOM_ID:
		PlayFabManager.client.login_with_custom_id(PlayFabManager.client_config.login_id, false, combined_info_request_params)
	else:
		PlayFabManager.client.login_with_custom_id(UUID.v4(), true, combined_info_request_params)


func _show_progess():
	$ProgressCenter/LoadingIndicator.show()

func _hide_progess():
	$ProgressCenter/LoadingIndicator.hide()


func _on_logged_in(login_result: LoginResult):
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

	$Login/Login.self_modulate = color_red
	$Login/Output.show()
	$Login/Output.bbcode_text = text


func _on_Back_pressed():
	SceneManager.goto_scene("res://Scenes/Main.tscn")


func _on_LoggedInBackButton_pressed():
	$LoggedIn.hide()
	update_login_button_states()
	$Login.show()
