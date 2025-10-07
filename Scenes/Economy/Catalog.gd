extends Control

@onready var card_scene: PackedScene = preload("res://Scenes/Widgets/ItemCard.tscn")

func _ready() -> void:
	%LoadingIndicator.show()
	PlayFabManager.catalog.search_complete.connect(_on_search_complete)
	PlayFabManager.catalog.fetch_catalog()

	var catalog: PlayFabCatalog = PlayFabCatalog.new()
	add_child(catalog)
	catalog.search_currency_complete.connect(_on_search_currency_complete)
	catalog.search_currency()


func _on_search_complete(result: Dictionary[String, CatalogItem]) -> void:
	for key in result.keys():
		var catalog_item: CatalogItem = result[key]
		var card: ItemCard = card_scene.instantiate()
		card.reset(catalog_item)
		%LoadingIndicator.hide()
		%ItemCardGridContainer.add_child(card)

func _on_search_currency_complete(result: Dictionary[String, CatalogItem]) -> void:
	for key in result.keys():
		var catalog_item: CatalogItem = result[key]
		var card: ItemCard = card_scene.instantiate()
		card.reset(catalog_item)
		%LoadingIndicator.hide()
		%CurrencyCardGridContainer.add_child(card)

func _on_back_button_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/Economy.tscn")
