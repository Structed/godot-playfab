@icon("res://addons/godot-playfab/icon.png")

extends Node
class_name PlayFabHttp


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
var _response_compression_enabled = true	# Whether to use response compression (gzip). If false, will send no `Accept-Encoding` header. If true, An `Accept-Encoding: gzip` header will be sent, and responses decoded with gzip.
var _response_compression_max_output_bytes = -1 # -1 is unlimited, but this could be very large! If you change this, be aware there is no error handling implemented to catch if the output size is too small! See https://docs.godotengine.org/en/3.5/classes/class_poolbytearray.html#class-poolbytearray-method-decompress-dynamic


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


func _http_request(request_method: int, body: Dictionary, path: String, callback: Callable, additional_headers: Dictionary = {}):
	var json = JSON.stringify(body)
	#print_debug(JSON.stringify(body, "\t"))
	var headers = [
		"Content-Type: application/json",
		"Content-Length: " + str(json.length()),
	]

	if _response_compression_enabled:
		headers.append("Accept-Encoding: gzip")

	headers.append_array(_dict_to_header_array(additional_headers))

	while (_request_in_progress):
		await _http.get_tree().process_frame

	_request_in_progress = true
	var request_uri = "%s%s" % [ _get_api_url(), path]
	var error = _http.request(request_uri, headers, request_method, json)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		return

	var args = await _http.request_completed
	# TODO: Perhaps build response object?
	var response_result = args[0] as int
	var response_code = args[1] as int
	var response_headers = args[2] as PackedStringArray
	var response_body = args[3] as PackedByteArray
	_request_in_progress = false

	var response_body_string = response_body.get_string_from_utf8()
	var test_json_conv = JSON.new()
	var parse_error = test_json_conv.parse(response_body_string)
	var json_parse_result = test_json_conv.data
	#print_debug("JSON Parse result: %s" % JSON.stringify(json_parse_result, "\t"))

	if parse_error != OK:
		emit_signal("json_parse_error", json_parse_result)
		return
	if response_code >= 200 and response_code < 400:
		if callback != null:
			if callback.is_valid():
				callback.call(json_parse_result)
			else:
				push_error("Response calback " + callback.get_method() + " is no longer valid! Make sure, a script is only removed after all requests returned!")
		return
	elif response_code >= 400:
		var apiErrorWrapper = ApiErrorWrapper.new()
		for key in json_parse_result.keys():
			apiErrorWrapper.set(key, json_parse_result[key])
		emit_signal("api_error", apiErrorWrapper)
		return
	if response_code >= 500:
		emit_signal("server_error", path)
		return


func _test_http(body, path: String):
	var error = _http.request("https://httpbin.org/post", [], HTTPClient.METHOD_POST, JSON.stringify(body))
	if error != OK:
		push_error("An error occurred in the HTTP request.")
