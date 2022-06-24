extends VBoxContainer


var key_value_line_edit_scene = preload("res://Scenes/Widgets/KeyValueLineEdit.tscn")


func _on_AddLineButton_pressed():
	var kvl = key_value_line_edit_scene.instance()
	$TableContainer.add_child(kvl)


func _on_SubmitButton_pressed():
	# if ($TableContainer.get_child_count() < 1):
	# 	return	# Nothing to do here!

	var path = $HBoxContainer/PathInput.text
	if path == "":
		push_error("No path set")

	var body_dict = {}

	for line in $TableContainer.get_children():
		var key = line.get_child(0).text
		var value = line.get_child(1).text

		body_dict[key] = value

	PlayFabManager.client._post_dict_auth(body_dict, path, PlayFab.AUTH_TYPE.SESSION_TICKET, funcref(self, "_on_get_response"))


func _on_get_response(response):
	$Response.text = JSON.print(response.data, "\t")


func _on_BackButton_pressed():
	SceneManager.goto_scene("res://Scenes/LoggedIn.tscn")

