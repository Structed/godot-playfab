extends VBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Register_pressed():
	var username = $HSplitContainer/Request/Name/Input.text
	var email = $HSplitContainer/Request/Email/Input.text
	var password = $HSplitContainer/Request/Password/Input.text
	Global.play_fab.register_email_password(username, email, password)
	if !Global.play_fab.is_connected("registered", self, "_on_registered"):
		Global.play_fab.connect("registered", self, "_on_registered", [], CONNECT_ONESHOT)

	if !Global.play_fab.is_connected("api_error", self, "_on_api_error"):
		Global.play_fab.connect("api_error", self, "_on_api_error", [], CONNECT_ONESHOT)


func _on_registered(result: RegisterPlayFabUserResult):
	$Register.self_modulate = Color(0, 1, 0, 0.5)

func _on_api_error(api_error_wrapper: ApiErrorWrapper):
	var text = ""
	var error_details = api_error_wrapper.errorDetails
		
	for key in error_details.keys():
		text += "[color=red][b]%s[/b][/color]: " % key 
		for element in error_details[key]:
			text += "%s\n" % element
		pass
	$HSplitContainer/Response/RichTextLabel.bbcode_text = text
	$Register.self_modulate = Color(1, 0, 0, 0.5)
	pass
