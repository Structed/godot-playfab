extends RefCounted
class_name PlayFabHttpResult

const CONTINUATION_TOKEN_KEY_NAME := "ContinuationToken"

var _json_parse_result: Dictionary


var response_result: int

var response_code: int

var response_headers: PackedStringArray

var response_body: PackedByteArray

var json_parse_result: Dictionary:
	get:
		return _json_parse_result

var _continuation_token: String = ""
var continuation_token: String:
	get:
		return _continuation_token

func _init(args) -> void:
	response_result = args[0] as int
	response_code = args[1] as int
	response_headers = args[2] as PackedStringArray
	response_body = args[3] as PackedByteArray

	_json_parse_result = _parse_response_body()

func _parse_response_body() -> Dictionary:
	var response_body_string: String = response_body.get_string_from_utf8()
	var test_json_conv = JSON.new()
	var parse_error = test_json_conv.parse(response_body_string)
	var json = test_json_conv.data

	if parse_error != OK:
		push_error("Failed to parse JSON response body.")

	return json

## Checks, whether the result has a continuation token.
func has_continuation_token() -> bool:
	var token: String = get_continuation_token()
	if token == null or token == "":
		return false
		
	return true

func get_continuation_token() -> String:
	_continuation_token = self._json_parse_result["data"].get(CONTINUATION_TOKEN_KEY_NAME, "")
	return _continuation_token
