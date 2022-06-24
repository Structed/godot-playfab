extends Node
class_name PlayFabHttp, "res://addons/godot-playfab/icon.png"


## Emitted when a JSON parse error occurs. Will receive a JSONResult as parameter.
## @param json_result: JSONResult
signal json_parse_error(json_result)

## Emitted when a PlayFab API (HTTP status code 4xx) error occurs. Will receive a LoginResult as parameter.
## @param api_error_wrapper: ApiErrorWrapper
signal api_error(api_error_wrapper)

## Emitted when a Server Error (HTTP status code 5xx) occurs when querying PlayFab. Will receive the request path as parameter.
## @param path: String
signal server_error(path)


var _http: HTTPRequest
var _request_in_progress = false
var _title_id: String
var _base_uri = "playfabapi.com"


func _ready():
	_http = HTTPRequest.new()
	add_child(_http)


func _dict_to_header_array(dict: Dictionary):
	if dict.size() < 1:
		return []

	var array = []
	for key in dict.keys():
		var value = "%s: %s" % [key, dict[key]]
		array.append(value)

	return array


func _get_api_url() -> String:
	return "https://%s.%s" % [ _title_id, _base_uri ]


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
