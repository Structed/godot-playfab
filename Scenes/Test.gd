extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Button_pressed():
	var request = GetTitleDataRequest.new()
	$PlayFabClient.get_title_data(request, funcref(self, "_callback"))
	SceneManager.goto_scene("res://Scenes/LoggedIn.tscn")


func _callback(data):
	print_debug(data)
