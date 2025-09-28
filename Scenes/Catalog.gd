extends Control

@onready var card_scene: PackedScene = preload("res://Scenes/Widgets/ItemCard.tscn")

func _ready() -> void:
	%LoadingIndicator.show()
	PlayFabManager.catalog.search_complete.connect(_on_search_complete)
	PlayFabManager.catalog._search_all_items()


func _on_search_complete(result: Dictionary[String, CatalogItem]) -> void:
	print("All item IDs:", PlayFabManager.catalog.search_results)
	for key in result.keys():
		var catalog_item: CatalogItem = result[key]
		var card: ItemCard = card_scene.instantiate()
		card.reset(catalog_item)
		%LoadingIndicator.hide()
		%CardGridContainer.add_child(card)


func _on_back_button_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/LoggedIn.tscn")
