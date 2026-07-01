extends Control

@onready var card_scene: PackedScene = preload("res://Scenes/Widgets/ItemCard.tscn")

func _ready() -> void:
	%LoadingIndicator.show()
	PlayFabManager.catalog.search_complete.connect(_on_search_complete)
	if PlayFabManager.catalog._has_full_catalog:
		_on_search_complete()
	else:
		PlayFabManager.catalog.fetch_catalog()


func _on_search_complete() -> void:
	var catalog := PlayFabManager.catalog.get_catalog()
	for key in catalog:
		var catalog_item: CatalogItem = catalog[key]
		var card: ItemCard = card_scene.instantiate()
		card.reset(catalog_item)
		if catalog_item.Type == CatalogItem.TYPE_CURRENCY:
			%LoadingIndicator.hide()
			%CurrencyCardGridContainer.add_child(card)
		else:
			%LoadingIndicator.hide()
			%ItemCardGridContainer.add_child(card)



func _on_back_button_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/Economy.tscn")
