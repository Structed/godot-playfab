extends Node
class_name Pf

var _http: HTTPRequest
var _title_id
var _base_uri = "playfabapi.com"

func _init(title_id: String):
	_title_id = title_id
	
func _ready():
	_http = HTTPRequest.new()
	add_child(_http)
	_base_uri = "https://%s.%s" % [ _title_id, _base_uri ]

func register_email_password(username: String, email: String, password: String):
	_http.connect("request_completed", self, "_on_register_email_password")	
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
	
func _on_register_email_password(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	_http.disconnect("request_completed", self, "_on_register_email_password")
	
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
