extends Control

@onready var card_scene: PackedScene = preload("res://Scenes/Widgets/ItemCard.tscn")

var inventory_items: Array = []

func _ready() -> void:
	%LoadingIndicator.show()

	var catalog: Dictionary[String, CatalogItem] = PlayFabManager.catalog.get_catalog()

	var turboload_complete: Callable = func(res: GetInventoryItemsResponse) -> void:
		for item in res.Items:
			var catalog_item: CatalogItem = resolve_catalog_item(item.Id, catalog)
			var card: ItemCard = card_scene.instantiate()
			card.reset(catalog_item)
			%LoadingIndicator.hide()
			%ItemCardGridContainer.add_child(card)

	PlayFabManager.inventory.turboload_inventory(turboload_complete)

func resolve_catalog_item(item_id: String, catalog: Dictionary[String, CatalogItem]) -> CatalogItem:
	var item = catalog.get(item_id, CatalogItem.new())
	return item


func _on_back_button_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/Economy.tscn")
