extends VBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Register_pressed():
	var username = $Name/Input.text
	var email = $Email/Input.text
	var password = $Password/Input.text
	Global.pf.register_email_password(username, email, password)
