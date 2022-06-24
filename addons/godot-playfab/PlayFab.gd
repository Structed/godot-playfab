extends Node
class_name PlayFab, "res://addons/godot-playfab/icon.png"


## Emitted when a JSON parse error occurs. Will receive a JSONResult as parameter.
## @param json_result: JSONResult
signal json_parse_error(json_result)

## Emitted when a PlayFab API (HTTP status code 4xx) error occurs. Will receive a LoginResult as parameter.
## @param api_error_wrapper: ApiErrorWrapper
signal api_error(api_error_wrapper)

## Emitted when a Server Error (HTTP status code 5xx) occurs when querying PlayFab. Will receive the request path as parameter.
## @param path: String
signal server_error(path)

## Arguments: RegisterPlayFabUserResult
signal registered(RegisterPlayFabUserResult)

## Emitted when the player logged in successfully
## @param login_result: LoginResult
signal logged_in(login_result)

enum AUTH_TYPE {SESSION_TICKET, ENTITY_TOKEN}


var _http: HTTPRequest
var _request_in_progress = false
var _title_id: String
var _base_uri = "playfabapi.com"


func _init():

	if ProjectSettings.has_setting(PlayFabConstants.SETTING_PLAYFAB_TITLE_ID) && ProjectSettings.get_setting(PlayFabConstants.SETTING_PLAYFAB_TITLE_ID) != "":
		_title_id = ProjectSettings.get_setting(PlayFabConstants.SETTING_PLAYFAB_TITLE_ID)
	else:
		push_error("Title Id was not set in ProjectSettings: %s" % PlayFabConstants.SETTING_PLAYFAB_TITLE_ID)


func _ready():
	_http = HTTPRequest.new()
	add_child(_http)
	connect("logged_in", self, "_on_logged_in")


func _get_api_url() -> String:
	return "https://%s.%s" % [ _title_id, _base_uri ]


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

	var result = _post(request_params, "/Client/RegisterPlayFabUser", funcref(self, "_on_register_email_password"))


func login_with_email(email: String, password: String, custom_tags: Dictionary, info_request_parameters: GetPlayerCombinedInfoRequestParams):
	PlayFabManager.client_config.login_type = PlayFabClientConfig.LoginType.LOGIN_EMAIL
	PlayFabManager.client_config.login_id = email

	var request_params = LoginWithEmailAddressRequest.new()
	request_params.TitleId = _title_id
	request_params.Email = email
	request_params.Password = password
	request_params.CustomTags = custom_tags
	request_params.InfoRequestParameters = info_request_parameters

	var result = _post(request_params, "/Client/LoginWithEmailAddress", funcref(self, "_on_login_with_email"))


func login_with_custom_id(custom_id: String, create_user: bool, info_request_parameters: GetPlayerCombinedInfoRequestParams):
	PlayFabManager.client_config.login_type = PlayFabClientConfig.LoginType.LOGIN_CUSTOM_ID
	PlayFabManager.client_config.login_id = custom_id

	var request_params = LoginWithCustomIdRequest.new()
	request_params.TitleId = _title_id
	request_params.CustomId = custom_id
	request_params.CreateAccount = create_user
	request_params.InfoRequestParameters = info_request_parameters

	var result = _post(request_params, "/Client/LoginWithCustomID", funcref(self, "_on_login_with_email"))


func _on_register_email_password(result: Dictionary):
	var register_result = RegisterPlayFabUserResult.new()
	register_result.from_dict(result["data"], register_result)

	emit_signal("registered", register_result)


func _on_login_with_email(result: Dictionary):
	var login_result = LoginResult.new()
	login_result.from_dict(result["data"], login_result)

	emit_signal("logged_in", login_result)


func _post_with_session_auth(body: JsonSerializable, path: String, callback: FuncRef, additional_headers: Dictionary = {}) -> bool:
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
# @param callback: FuncRef							- A callback which will be called once the request **succeeds**
# @param additional_headers: Dictionary (optional)	- Additional headers to be sent with the request
# @ returns: bool									- False if the player is not logged in - true if the request was sent.
func _post_with_entity_auth(body: JsonSerializable, path: String, callback: FuncRef, additional_headers: Dictionary = {}) -> bool:
	var result = _add_auth_headers(additional_headers, AUTH_TYPE.ENTITY_TOKEN)
	if !result:
		return false

	var dict = body.to_dict()
	_http_request(HTTPClient.METHOD_POST, dict, path, callback, additional_headers)
	return true


func _post(body: JsonSerializable, path: String, callback: FuncRef, additional_headers: Dictionary = {}):
	var dict = body.to_dict()
	_http_request(HTTPClient.METHOD_POST, dict, path, callback, additional_headers)


# General (POST) request method for endpoints which require Authentication.
# You should use this to provide custom requests by passing parameters as a Dictionary.
#
# @visibility: internal
# @param body: Dictionary							- A Dictionary representing the request body
# @param path: String								- The request path, e.g. `/Client/GetTitleData`
# @param auth_type: PlayFab.AUTH_TYPE				- One of `PlayFab.AUTH_TYPE`
# @param callback: FuncRef							- A callback which will be called once the request **succeeds**
# @param additional_headers: Dictionary (optional)	- Additional headers to be sent with the request
func _post_dict_auth(body: Dictionary, path: String, auth_type, callback: FuncRef, additional_headers: Dictionary = {}):
	_add_auth_headers(additional_headers, auth_type)
	_http_request(HTTPClient.METHOD_POST, body, path, callback, additional_headers)


# General (POST) request method for endpoints which **DO NOT** require Authentication.
# However, you can add auth parameters yourself via appropriate headers.
# You should use this to provide custom requests by passing parameters as a Dictionary.
#
# @visibility: internal
# @param body: Dictionary							- A Dictionary representing the request body
# @param path: String								- The request path, e.g. `/Client/GetTitleData`
# @param callback: FuncRef							- A callback which will be called once the request **succeeds**
# @param additional_headers: Dictionary (optional)	- Additional headers to be sent with the request
func _post_dict(body: Dictionary, path: String, callback: FuncRef, additional_headers: Dictionary = {}):
	_http_request(HTTPClient.METHOD_POST, body, path, callback, additional_headers)


# Adds PlayFab specific authentication headers depending on the `auth_type` provided.
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


func _dict_to_header_array(dict: Dictionary):
	if dict.size() < 1:
		return []

	var array = []
	for key in dict.keys():
		var value = "%s: %s" % [key, dict[key]]
		array.append(value)

	return array


func _http_request(request_method: int, body: Dictionary, path: String, callback: FuncRef, additional_headers: Dictionary = {}):
	var json = JSON.print(body)
	#print_debug(JSON.print(body, "\t"))
	var headers = ["Content-Type: application/json", "Content-Length: " + str(json.length())]
	headers.append_array(_dict_to_header_array(additional_headers))

	while (_request_in_progress):
		yield(_http.get_tree(), "idle_frame")

	_request_in_progress = true
	var request_uri = "%s%s" % [ _get_api_url(), path]
	var error = _http.request(request_uri, headers, true, request_method, json)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		return

	var args = yield(_http, "request_completed")
	# TODO: Perhaps build response object?
	var response_result = args[0]
	var response_code = args[1]
	var response_headers = args[2]
	var response_body = args[3]
	_request_in_progress = false

	var response_body_string = response_body.get_string_from_utf8()
	var json_parse_result = JSON.parse(response_body_string)
	#print_debug("JSON Parse result: %s" % JSON.print(json_parse_result.result, "\t"))

	if json_parse_result.error != OK:
		emit_signal("json_parse_error", json_parse_result)
		return
	if response_code >= 200 and response_code < 400:
		callback.call_func(json_parse_result.result)
		return
	elif response_code >= 400:
		var apiErrorWrapper = ApiErrorWrapper.new()
		for key in json_parse_result.result.keys():
			apiErrorWrapper.set(key, json_parse_result.result[key])
		emit_signal("api_error", apiErrorWrapper)
		return
	if response_code >= 500:
		emit_signal("server_error", path)
		return


func _test_http(body, path: String):
	var error = _http.request("https://httpbin.org/post", [], true, HTTPClient.METHOD_POST, JSON.print(body))
	if error != OK:
		push_error("An error occurred in the HTTP request.")
