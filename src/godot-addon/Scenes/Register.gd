extends VBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Register_pressed():
	var username = $HSplitContainer/Request/Name/Input.text
	var email = $HSplitContainer/Request/Email/Input.text
	var password = $HSplitContainer/Request/Password/Input.text
	Global.play_fab.register_email_password(username, email, password)
	Global.play_fab.connect("logged_in", self, "_on_logged_in")
	Global.play_fab.connect("api_error", self, "_on_api_error")
	
func _on_logged_in(login_result: LoginResult):
	pass

func _on_api_error(api_error_wrapper: ApiErrorWrapper):
	var text = ""
	var error_details = api_error_wrapper.errorDetails
		
	for key in error_details.keys():
		text += "[color=red][b]%s[/b][/color]: " % key 
		for element in error_details[key]:
			text += "%s\n" % element
		pass
	$HSplitContainer/Response/RichTextLabel.bbcode_text = text
	pass
