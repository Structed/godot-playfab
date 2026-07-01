@tool
extends EditorPlugin

const AUTOLOAD_NAME = "ToastParty"
func _enter_tree():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/toastparty/toast-autoload.gd")

func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_NAME)
