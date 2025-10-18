extends Control


func _on_catalog_button_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/Economy/Catalog.tscn")


func _on_inventory_button_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/Economy/Inventory.tscn")


func _on_steam_inventory_button_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/Economy/SteamInventory.tscn")


func _on_steam_purchase_button_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/Economy/SteamPurchase.tscn")


func _on_back_button_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/LoggedIn.tscn")
