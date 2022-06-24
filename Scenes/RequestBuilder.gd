extends VBoxContainer


var key_value_line_edit_scene = preload("res://Scenes/Widgets/KeyValueLineEdit.tscn")


func _on_AddLineButton_pressed():
	var kvl = key_value_line_edit_scene.instance()
	$TableContainer.add_child(kvl)

func _on_BackButton_pressed():
	SceneManager.goto_scene("res://Scenes/LoggedIn.tscn")

