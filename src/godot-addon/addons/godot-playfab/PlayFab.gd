extends Node
class_name PlayFab

## Emitted when a JSON parse error occurs. Will receive a JSONResult as parameter.
## @param json_result: JSONResult
signal json_parse_error(json_result)

## Emitted when a PlayFab API error occurs. Will receive a LoginResult as parameter.
## @param api_error_wrapper: ApiErrorWrapper
signal api_error(api_error_wrapper)

## Emitted, when a Server Error (code 500) occurs when querying PlayFab
## @param path: String
signal server_error(path)

## Emitted when a request succeeded
## @param response: Dictionary - a dictionary of all the response parameters
signal request_succeeded(response)

## Arguments: RegisterPlayFabUserResult
signal registered(RegisterPlayFabUserResult)

var _http: HTTPRequest
var _request_in_progress = false
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
	var params = {
		"TitleId": _title_id,
		"DisplayName": username,
		"Username": username,
		"Email": email,
		"Password": password,
		"InfoRequestParameters": "", # TODO: Figure out what that is
		"RequireBothUsernameAndEmail": "true"
	}
	var result = _post(params, "/Client/RegisterPlayFabUser", funcref(self, "_on_register_email_password"))


func _on_register_email_password(result: Dictionary):
	var register_result = RegisterPlayFabUserResult.new()
	var data = result["data"]
	for key in data.keys():
		register_result.set(key, data[key])
		
	emit_signal("registered", register_result)
	
func _post(body, path: String, callback: FuncRef):
	var json = JSON.print(body)
	var headers = ["Content-Type: application/json", "Content-Length: " + str(json.length())]
	
	while (_request_in_progress):
		yield(_http.get_tree(), "idle_frame")
	
	_request_in_progress = true
	var error = _http.request("%s%s" % [ _base_uri, path], headers, true, HTTPClient.METHOD_POST, json)
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
	
	var json_parse_result = JSON.parse(response_body.get_string_from_utf8())
	print_debug("JSON Parse result: %s" % json_parse_result.result)
	
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
