extends Object
class_name PlayFab

var http: HTTPClient
var base_uri = "playfabapi.com"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _init(title_id: String):
	http = HTTPClient.new()
	
	var connect_response_code = http.connect_to_host("%s.%s" % [title_id, base_uri], -1, true, true)
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
