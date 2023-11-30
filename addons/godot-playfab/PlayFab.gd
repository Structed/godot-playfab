@icon("res://addons/godot-playfab/icon.png")

extends PlayFabHttp
class_name PlayFab

## Arguments: RegisterPlayFabUserResult
signal registered(RegisterPlayFabUserResult)

## Emitted when the player logged in successfully
## @param login_result: LoginResult
signal logged_in(login_result)

enum AUTH_TYPE {SESSION_TICKET, ENTITY_TOKEN}


func _init():

	if ProjectSettings.has_setting(PlayFabConstants.SETTING_PLAYFAB_TITLE_ID) && ProjectSettings.get_setting(PlayFabConstants.SETTING_PLAYFAB_TITLE_ID) != "":
		_title_id = ProjectSettings.get_setting(PlayFabConstants.SETTING_PLAYFAB_TITLE_ID)
	else:
		push_error("Title Id was not set in ProjectSettings: %s" % PlayFabConstants.SETTING_PLAYFAB_TITLE_ID)


func _ready():
	super._ready()
	connect("logged_in",Callable(self,"_on_logged_in"))


func _on_logged_in(login_result: LoginResult):
	# Setting SessionTicket for subsequent client requests
	PlayFabManager.client_config.session_ticket = login_result.SessionTicket
	PlayFabManager.client_config.master_player_account_id = login_result.PlayFabId
	PlayFabManager.client_config.entity_token = login_result.EntityToken
	PlayFabManager.save_client_config()


func register_email_password(username: String, email: String, password: String, info_request_parameters: GetPlayerCombinedInfoRequestParams):
	var request_params = RegisterPlayFabUserRequest.new()
	request_params.TitleId = _title_id
	request_params.DisplayName = username
	request_params.Username = username
	request_params.Email = email
	request_params.Password = password
	request_params.InfoRequestParameters = info_request_parameters
	request_params.RequireBothUsernameAndEmail = true

	var result = _post(request_params, "/Client/RegisterPlayFabUser", Callable(self, "_on_register_email_password"))


func login_with_email(email: String, password: String, custom_tags: Dictionary, info_request_parameters: GetPlayerCombinedInfoRequestParams):
	PlayFabManager.client_config.login_type = PlayFabClientConfig.LoginType.LOGIN_EMAIL
	PlayFabManager.client_config.login_id = email

	var request_params = LoginWithEmailAddressRequest.new()
	request_params.TitleId = _title_id
	request_params.Email = email
	request_params.Password = password
	request_params.CustomTags = custom_tags
	request_params.InfoRequestParameters = info_request_parameters

	var result = _post(request_params, "/Client/LoginWithEmailAddress", Callable(self, "_on_login_with_email"))


func login_with_custom_id(custom_id: String, create_user: bool, info_request_parameters: GetPlayerCombinedInfoRequestParams):
	PlayFabManager.client_config.login_type = PlayFabClientConfig.LoginType.LOGIN_CUSTOM_ID
	PlayFabManager.client_config.login_id = custom_id

	var request_params = LoginWithCustomIdRequest.new()
	request_params.TitleId = _title_id
	request_params.CustomId = custom_id
	request_params.CreateAccount = create_user
	request_params.InfoRequestParameters = info_request_parameters

	var result = _post(request_params, "/Client/LoginWithCustomID", Callable(self, "_on_login_with_email"))

# Anonymous login with a GUID as username
func login_anonymous():
	var combined_info_request_params = GetPlayerCombinedInfoRequestParams.new()
	combined_info_request_params.show_all()
	var player_profile_view_constraints = PlayerProfileViewConstraints.new()
	combined_info_request_params.ProfileConstraints = player_profile_view_constraints

	PlayFabManager.client.login_with_custom_id(UUID.v4(), true, combined_info_request_params)

func _on_register_email_password(result: Dictionary):
	var register_result = RegisterPlayFabUserResult.new()
	register_result.from_dict(result["data"], register_result)

	emit_signal("registered", register_result)


func _on_login_with_email(result: Dictionary):
	var login_result = LoginResult.new()
	login_result.from_dict(result["data"], login_result)

	emit_signal("logged_in", login_result)


func _post_with_session_auth(body: JsonSerializable, path: String, callback: Callable, additional_headers: Dictionary = {}) -> bool:
	var result = _add_auth_headers(additional_headers, AUTH_TYPE.SESSION_TICKET)
	if !result:
		return false

	var dict = body.to_dict()
	_http_request(HTTPClient.METHOD_POST, dict, path, callback, additional_headers)
	return true

# General request method for endpoints which require Entity-Token-Auth.
# You should use this to provide convenience methods for requests to specific resources.
#
# @visibility: internal
# @param body: JsonSerializable						- A data model valid for the request to be made
# @param path: String								- The request path, e.g. `/Client/GetTitleData`
# @param callback: Callable							- A callback which will be called once the request **succeeds**
# @param additional_headers: Dictionary (optional)	- Additional headers to be sent with the request
# @ returns: bool									- False if the player is not logged in - true if the request was sent.
func _post_with_entity_auth(body: JsonSerializable, path: String, callback: Callable, additional_headers: Dictionary = {}) -> bool:
	var result = _add_auth_headers(additional_headers, AUTH_TYPE.ENTITY_TOKEN)
	if !result:
		return false

	var dict = body.to_dict()
	_http_request(HTTPClient.METHOD_POST, dict, path, callback, additional_headers)
	return true


func _post(body: JsonSerializable, path: String, callback: Callable, additional_headers: Dictionary = {}):
	var dict = body.to_dict()
	_http_request(HTTPClient.METHOD_POST, dict, path, callback, additional_headers)


# General (POST) request method for endpoints which require Authentication.
# You should use this to provide custom requests by passing parameters as a Dictionary.
#
# @visibility: internal
# @param body: Dictionary							- A Dictionary representing the request body
# @param path: String								- The request path, e.g. `/Client/GetTitleData`
# @param auth_type: PlayFab.AUTH_TYPE				- One of `PlayFab.AUTH_TYPE`
# @param callback: Callable							- A callback which will be called once the request **succeeds**
# @param additional_headers: Dictionary (optional)	- Additional headers to be sent with the request
func post_dict_auth(body: Dictionary, path: String, auth_type, callback: Callable, additional_headers: Dictionary = {}):
	_add_auth_headers(additional_headers, auth_type)
	_http_request(HTTPClient.METHOD_POST, body, path, callback, additional_headers)


# General (POST) request method for endpoints which **DO NOT** require Authentication.
# However, you can add auth parameters yourself via appropriate headers.
# You should use this to provide custom requests by passing parameters as a Dictionary.
#
# @visibility: internal
# @param body: Dictionary							- A Dictionary representing the request body
# @param path: String								- The request path, e.g. `/Client/GetTitleData`
# @param callback: Callable							- A callback which will be called once the request **succeeds**
# @param additional_headers: Dictionary (optional)	- Additional headers to be sent with the request
func post_dict(body: Dictionary, path: String, callback: Callable, additional_headers: Dictionary = {}):
	_http_request(HTTPClient.METHOD_POST, body, path, callback, additional_headers)


# Adds PlayFab specific authentication headers depending checked the `auth_type` provided.
#
# @visibility: internal
# @param additional_headers: Dictionary				- Authentication headers will be appended to this Dictionary
# @param auth_type: PlayFab.AUTH_TYPE				- One of `PlayFab.AUTH_TYPE`
# @return bool:										- Whethr the player is authenticated. True if authenticated.
func _add_auth_headers(additional_headers: Dictionary, auth_type) -> bool:
	if !PlayFabManager.client_config.is_logged_in():
		push_error("Player is not logged in.")
		return false

	if auth_type == AUTH_TYPE.SESSION_TICKET:
		additional_headers["X-Authorization"] = PlayFabManager.client_config.session_ticket
	elif auth_type == AUTH_TYPE.ENTITY_TOKEN:
		additional_headers["X-EntityToken"] = PlayFabManager.client_config.entity_token.EntityToken
	else:
		push_error("auth_type \"" + auth_type + "\" is invalid")

	return true
