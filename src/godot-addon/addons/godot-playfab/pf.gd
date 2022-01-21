extends Object
class_name PlayFab

var _title_id: String
var http: HTTPClient
var base_uri = "playfabapi.com"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _init(title_id: String):
	http = HTTPClient.new()
	_title_id = title_id
	
	var connect_response_code = http.connect_to_host("%s.%s" % [_title_id, base_uri], -1, true, true)
	assert(connect_response_code == OK, connect_response_code) # Make sure connection is OK.
	
		# Wait until resolved and connected.
	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		print("Connecting...")
		if not OS.has_feature("web"):
			OS.delay_msec(500)
		else:
			yield(Engine.get_main_loop(), "idle_frame")

	assert(http.get_status() == HTTPClient.STATUS_CONNECTED, http.get_status()) # Check if the connection was made successfully.

func _post(fields):
	var body = http.query_string_from_dict(fields)
	var headers = ["Content-Type: application/x-www-form-urlencoded", "Content-Length: " + str(body.length())]
	var error = http.request(http.METHOD_POST, "/Client/RegisterPlayFabUser", headers, body)
	if error > OK:
		print("There was an error %d" % error)
	else:
		print_debug("Has response? %s" % http.has_response())
		_parse_response()
	return error
	
func _parse_response():
	if http.has_response():
		# If there is a response...
		var headers = http.get_response_headers_as_dictionary() # Get response headers.
		print("code: ", http.get_response_code()) # Show response code.
		print("**headers:\\n", headers) # Show headers.

		# Getting the HTTP Body

		if http.is_response_chunked():
			# Does it use chunks?
			print("Response is Chunked!")
		else:
			# Or just plain Content-Length
			var bl = http.get_response_body_length()
			print("Response Length: ", bl)

		# This method works for both anyway

		var rb = PoolByteArray() # Array that will hold the data.

		while http.get_status() == HTTPClient.STATUS_BODY:
			# While there is body left to be read
			http.poll()
			# Get a chunk.
			var chunk = http.read_response_body_chunk()
			if chunk.size() == 0:
				if not OS.has_feature("web"):
					# Got nothing, wait for buffers to fill a bit.
					OS.delay_usec(1000)
				else:
					yield(Engine.get_main_loop(), "idle_frame")
			else:
				rb = rb + chunk # Append to read buffer.
		# Done!

		print("bytes got: ", rb.size())
		var text = rb.get_string_from_ascii()
		print("Text: ", text)
	

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
	_post(params) # TODO: work with the result
	
	
	
#
#Request Body
#REQUEST BODY
#Name	Required	Type	Description
#TitleId	True	
#string
#Unique identifier for the title, found in the Settings > Game Properties section of the PlayFab developer site when a title has been selected.
#
#CustomTags		
#object
#The optional custom tags associated with the request (e.g. build number, external trace identifiers, etc.).
#
#DisplayName		
#string
#An optional parameter for setting the display name for this title (3-25 characters).
#
#Email		
#string
#User email address attached to their account
#
#EncryptedRequest		
#string
#Base64 encoded body that is encrypted with the Title's public RSA key (Enterprise Only).
#
#InfoRequestParameters		
#GetPlayerCombinedInfoRequestParams
#Flags for which pieces of info to return for the user.
#
#Password		
#string
#Password for the PlayFab account (6-100 characters)
#
#PlayerSecret		
#string
#Player secret that is used to verify API request signatures (Enterprise Only).
#
#RequireBothUsernameAndEmail		
#boolean
#An optional parameter that specifies whether both the username and email parameters are required. If true, both parameters are required; if false, the user must supply either the username or email parameter. The default value is true.
#
#Username		
#string
#PlayFab username for the account (3-20 characters)
#
#Responses
#RESPONSES
#Name	Type	Description
#200 OK	
#RegisterPlayFabUserResult
#Each account must have a unique email address in the PlayFab service. Once created, the account may be associated with additional accounts (Steam, Facebook, Game Center, etc.), allowing for added social network lists and achievements systems.
#
#400 Bad Request	
#ApiErrorWrapper
#This is the outer wrapper for all responses with errors
#
