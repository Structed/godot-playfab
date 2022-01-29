extends Node
class_name PlayFab

## Emitted when a JSON parse error occurs. Will receive a JSONResult as parameter.
signal json_parse_error(json_result)

## Emitted when a PlayFab API error occurs. Will receive a LoginResult as parameter.
signal api_error(LoginResult)

## Arguments: RegisterPlayFabUserResult
signal registered(RegisterPlayFabUserResult)

var _http: HTTPRequest
var _title_id
var _base_uri = "playfabapi.com"
var _emit_counter = 0

func _init(title_id: String):
	_title_id = title_id
	
func _ready():
	_http = HTTPRequest.new()
	add_child(_http)
	_base_uri = "https://%s.%s" % [ _title_id, _base_uri ]

func register_email_password(username: String, email: String, password: String):
	_http.connect("request_completed", self, "_on_register_email_password", [], CONNECT_ONESHOT)
	var params = {
		"TitleId": _title_id,
		"DisplayName": username,
		"Username": username,
		"Email": email,
		"Password": password,
		"InfoRequestParameters": "", # TODO: Figure out what that is
		"RequireBothUsernameAndEmail": "true"
	}
	_post(params, "/Client/RegisterPlayFabUser")
	
func _on_register_email_password(result, response_code: int, headers, body):
	var json_result = JSON.parse(body.get_string_from_utf8())
	if json_result.error == OK:
		print_debug("JSON Parse result: %s" % json_result.result)
	else:
		emit_signal("json_parse_error", json_result)
		return
		
	var result_dict: Dictionary = json_result.result
	if (response_code >= 200 && response_code < 300):
		var login_result = RegisterPlayFabUserResult.new()
		var data = result_dict["data"]
		for key in data.keys():
			login_result.set(key, data[key])
			
		emit_signal("registered", login_result)
	elif (response_code >= 400):
		var apiErrorWrapper = ApiErrorWrapper.new()
		for key in result_dict.keys():
			apiErrorWrapper.set(key, result_dict[key])
			
		emit_signal("api_error", apiErrorWrapper)
	
func _post(body, path: String):
	var json = JSON.print(body)
	var headers = ["Content-Type: application/json", "Content-Length: " + str(json.length())]
	var error = _http.request("%s%s" % [ _base_uri, path], headers, true, HTTPClient.METHOD_POST, json)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		
func _test_http(body, path: String):
	var error = _http.request("https://httpbin.org/post", [], true, HTTPClient.METHOD_POST, JSON.print(body))
	if error != OK:
		push_error("An error occurred in the HTTP request.")
