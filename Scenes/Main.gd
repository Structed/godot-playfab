extends Control

func _ready():
	# determine whether godot-steam addon is enabled
	if ClassDB.can_instantiate("Steam"):
		%LoginWithSteam.disabled = true
		PlayFabSteam.connect("logged_in", _on_logged_in) # Enable, if using GodotSteam/PlayFabSteam (4.4.1+)
	else:
		print_debug("Steam is NOT installed")
		%LoginWithSteam.visible = false
		%LoginWithSteam.disconnect("pressed", _on_login_with_steam_pressed)
		%StatusLabel.text = "Steam wasn't detected."

func _on_Register_pressed():
	SceneManager.goto_scene("res://Scenes/Register.tscn")

func _on_Login_pressed():
	SceneManager.goto_scene("res://Scenes/Login.tscn")

func _on_login_with_steam_pressed():
	SceneManager.goto_scene("res://Scenes/LoggedIn.tscn")

func _on_logged_in(playfab_id: String, steam_persona_name: String) -> void:
	print_debug("PlayFab ID: %s\nSteam Persona: %s" % [ playfab_id, steam_persona_name ])
	%LoginWithSteam.disabled = false
	%StatusLabel.text = "Steam initialized!\nPlayFab ID %s\nSteam Persona: \"%s\"" % [ playfab_id, steam_persona_name ]
