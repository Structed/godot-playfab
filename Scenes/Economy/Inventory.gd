extends Control

@onready var card_scene: PackedScene = preload("res://Scenes/Widgets/ItemCard.tscn")

var inventory_items: Array = []

func _ready() -> void:
	_update_inventory()

func _update_inventory() -> void:
	%LoadingIndicator.show()

	var catalog: Dictionary[String, CatalogItem] = PlayFabManager.catalog.get_catalog()
	var inventory: Dictionary[String, InventoryItem] = PlayFabManager.inventory.get_inventory()
	for id in inventory:
		var inventory_item: InventoryItem = inventory[id]
		var catalog_item: CatalogItem = resolve_catalog_item(inventory_item.Id, catalog)
		var card: ItemCard = card_scene.instantiate()
		card.reset(catalog_item)

		if inventory_item.Type == CatalogItem.TYPE_CURRENCY:
			%CurrencyCardGridContainer.add_child(card)
		else:
			%ItemCardGridContainer.add_child(card)


	%LoadingIndicator.hide()

func _clear_inventory() -> void:
	for child in %CurrencyCardGridContainer.get_children():
		%CurrencyCardGridContainer.remove_child(child)
		child.queue_free()

	for child in %ItemCardGridContainer.get_children():
		%ItemCardGridContainer.remove_child(child)
		child.queue_free()

func resolve_catalog_item(item_id: String, catalog: Dictionary[String, CatalogItem]) -> CatalogItem:
	var item = catalog.get(item_id, CatalogItem.new())
	return item

func _on_back_button_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/Economy.tscn")


func _on_referesh_button_pressed() -> void:
	%LoadingIndicator.show()
	_clear_inventory()
	PlayFabManager.inventory.turboload_inventory(func():
		_update_inventory()
	)
