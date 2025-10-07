extends Control

@onready var card_scene: PackedScene = preload("res://Scenes/Widgets/ItemCard.tscn")

func _ready() -> void:
	%LoadingIndicator.show()
	PlayFabManager.inventory.get_inventory_items(GetInventoryItemsRequest.new(), _on_get_inventory_complete)

	#var catalog: PlayFabCatalog = PlayFabCatalog.new()
	#add_child(catalog)
	#catalog.search_currency_complete.connect(_on_search_currency_complete)
	#catalog.search_currency()


func _on_get_inventory_complete(result: Dictionary) -> void:
	var res = GetInventoryItemsResponse.new()
	res.from_dict(result.data, res)
		
	for item in res.Items:
		var catalog_item: CatalogItem = item
		var card: ItemCard = card_scene.instantiate()
		card.reset(catalog_item)
		%LoadingIndicator.hide()
		%ItemCardGridContainer.add_child(card)

func _on_back_button_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/Economy.tscn")
