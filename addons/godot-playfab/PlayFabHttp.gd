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

	api_error.connect(func(api_error_wrapper: ApiErrorWrapper):
		var text = "[b]%s[/b]\n\n" % api_error_wrapper.errorMessage
		var error_details = api_error_wrapper.errorDetails

		if error_details:
			for key in error_details.keys():
				text += "[color=red][b]%s[/b][/color]: " % key
				for element in error_details[key]:
					text += "%s\n" % element

		print_rich(text)
	)

	server_error.connect(func(path: String):
		push_error("A server error occured while querying %s" % path)
	)


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
	var http_response: PlayFabHttpResult = await _individual_http_request(request_method, body, path, callback, additional_headers)
	if http_response.response_code >= 200 and http_response.response_code < 400:
		if callback != null:
			if callback.is_valid():
				callback.call(http_response.json_parse_result)
			else:
				push_error("Response calback " + callback.get_method() + " is no longer valid! Make sure, a script is only removed after all requests returned!")
		return
	elif http_response.response_code >= 400:
		var apiErrorWrapper = ApiErrorWrapper.new()
		for key in http_response.json_parse_result.keys():
			apiErrorWrapper.set(key, http_response.json_parse_result[key])
		api_error.emit(apiErrorWrapper)
		return
	if http_response.response_code >= 500:
		server_error.emit(path)
		return


func _individual_http_request(request_method: int, body: Dictionary, path: String, callback: Callable, additional_headers: Dictionary = {}) -> PlayFabHttpResult:
	# Create a new HTTPRequest instance for each request
	var http_request = HTTPRequest.new()
	add_child(http_request)

	var json = JSON.stringify(body)
	var headers = [
		"Content-Type: application/json",
		"Content-Length: " + str(json.length()),
	]

	if _response_compression_enabled:
		headers.append("Accept-Encoding: gzip")

	headers.append_array(_dict_to_header_array(additional_headers))

	var request_uri = "%s%s" % [ _get_api_url(), path]
	var error = http_request.request(request_uri, headers, request_method, json)

	if error != OK:
		push_error("An error occurred in the HTTP request.")
		return

	# Use await to wait for *this specific request* to complete
	var args = await http_request.request_completed

	# After the request completes, remove the node
	http_request.queue_free()

	var http_result := PlayFabHttpResult.new(args)
	return http_result
