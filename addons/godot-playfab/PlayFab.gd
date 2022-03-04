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


var _http: HTTPRequest
var _request_in_progress = false
var _title_id: String
var _playfab_client_config: PlayFabClientConfig


func _init():
	
	if ProjectSettings.has_setting(PlayFabConstants.SETTING_PLAYFAB_TITLE_ID) && ProjectSettings.get_setting(PlayFabConstants.SETTING_PLAYFAB_TITLE_ID) != "":
		_title_id = ProjectSettings.get_setting(PlayFabConstants.SETTING_PLAYFAB_TITLE_ID)
		_playfab_client_config = PlayFabClientConfig.new(_title_id)
	else:
		push_error("Title Id was not set in ProjectSettings: %s" % PlayFabConstants.SETTING_PLAYFAB_TITLE_ID)



func _ready():
	_http = HTTPRequest.new()
	add_child(_http)
	connect("logged_in", self, "_on_logged_in")
	

func _on_logged_in(login_result: LoginResult):
	# Setting SessionTicket for subsequent client requests
	_playfab_client_config.session_ticket = login_result.SessionTicket


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
	var request_params = LoginWithEmailAddressRequest.new()
	request_params.TitleId = _title_id
	request_params.Email = email
	request_params.Password = password
	request_params.CustomTags = custom_tags
	request_params.InfoRequestParameters = info_request_parameters
	
	var result = _post(request_params, "/Client/LoginWithEmailAddress", funcref(self, "_on_login_with_email"))


func _on_register_email_password(result: Dictionary):
	var register_result = RegisterPlayFabUserResult.new()
	register_result.from_dict(result["data"], register_result)
		
	emit_signal("registered", register_result)


func _on_login_with_email(result: Dictionary):
	var login_result = LoginResult.new()
	login_result.from_dict(result["data"], login_result)
	
	emit_signal("logged_in", login_result)


func _post_with_session_auth(body: JsonSerializable, path: String, callback: FuncRef, additional_headers: Dictionary = {}) -> bool:
	if !_playfab_client_config.is_logged_in():
		push_error("Player is not logged in.")
		return false


	additional_headers["X-Authorization"] = _playfab_client_config.session_ticket
	var dict = body.to_dict()
	_http_request(HTTPClient.METHOD_POST, dict, path, callback, additional_headers)
	return true


func _post(body: JsonSerializable, path: String, callback: FuncRef, additional_headers: Dictionary = {}):
	var dict = body.to_dict()
	_http_request(HTTPClient.METHOD_POST, dict, path, callback, additional_headers)


func _post_dict(body: Dictionary, path: String, callback: FuncRef, additional_headers: Dictionary = {}):
	_http_request(HTTPClient.METHOD_POST, body, path, callback, additional_headers)


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
	var headers = ["Content-Type: application/json", "Content-Length: " + str(json.length())]
	headers.append_array(_dict_to_header_array(additional_headers))
	
	while (_request_in_progress):
		yield(_http.get_tree(), "idle_frame")
	
	_request_in_progress = true
	var request_uri = "%s%s" % [ _playfab_client_config.api_url, path]
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
	print_debug("JSON Parse result: %s" % JSON.print(json_parse_result.result, "\t"))
		
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


func client_get_title_data(request_data: GetTitleDataRequest, callback: FuncRef):
	_post_with_session_auth(request_data, "/Client/GetTitleData", callback)


func _test_http(body, path: String):
	var error = _http.request("https://httpbin.org/post", [], true, HTTPClient.METHOD_POST, JSON.print(body))
	if error != OK:
		push_error("An error occurred in the HTTP request.")
