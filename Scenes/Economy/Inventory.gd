extends Control

@onready var card_scene: PackedScene = preload("res://Scenes/Widgets/ItemCard.tscn")

var inventory_items: Array = []

func _ready() -> void:
	%LoadingIndicator.show()

	var catalog: Dictionary[String, CatalogItem] = PlayFabManager.catalog.get_catalog()

	var inventory: Dictionary[String, InventoryItem] = PlayFabManager.inventory.get_inventory()
	for id in inventory:
		var item: InventoryItem = inventory[id]
		var catalog_item: CatalogItem = resolve_catalog_item(item.Id, catalog)
		var card: ItemCard = card_scene.instantiate()
		card.reset(catalog_item)
		%LoadingIndicator.hide()

		if item.Type == "currency":
			%CurrencyCardGridContainer.add_child(card)
		else:
			%ItemCardGridContainer.add_child(card)

func resolve_catalog_item(item_id: String, catalog: Dictionary[String, CatalogItem]) -> CatalogItem:
	var item = catalog.get(item_id, CatalogItem.new())
	return item


func _on_back_button_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/Economy.tscn")
