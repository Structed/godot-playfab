extends Control

## Steam Inventory Scene - Displays items from the logged-in Steam user's inventory

@onready var card_scene: PackedScene = preload("res://Scenes/Widgets/SteamItemCard.tscn")

var steam_available: bool = false
var _signals_connected: bool = false

func _ready() -> void:
	# Check if Steam is available
	if not ClassDB.can_instantiate("Steam"):
		_show_steam_not_available()
		return

	if not Steam.isSteamRunning():
		_show_steam_not_available()
		return

	steam_available = true

	# Connect to PlayFabSteam signals if available
	if PlayFabSteam.has_signal("inventory_updated") and not PlayFabSteam.inventory_updated.is_connected(_on_steam_inventory_updated):
		PlayFabSteam.inventory_updated.connect(_on_steam_inventory_updated)

	_load_steam_inventory()


func _show_steam_not_available() -> void:
	%LoadingIndicator.hide()
	%NoSteamLabel.show()
	%RefreshButton.disabled = true


func _load_steam_inventory() -> void:
	if not steam_available:
		return

	%LoadingIndicator.show()
	%NoSteamLabel.hide()
	_clear_inventory()

	# Disconnect previous signal connections to avoid duplicates
	if _signals_connected:
		if Steam.inventory_definition_update.is_connected(_on_inventory_definition_update):
			Steam.inventory_definition_update.disconnect(_on_inventory_definition_update)
		if Steam.inventory_result_ready.is_connected(_on_inventory_result_ready):
			Steam.inventory_result_ready.disconnect(_on_inventory_result_ready)

	# Request inventory from Steam
	# First load item definitions
	Steam.inventory_definition_update.connect(_on_inventory_definition_update, CONNECT_ONE_SHOT)
	Steam.inventory_result_ready.connect(_on_inventory_result_ready, CONNECT_ONE_SHOT)
	_signals_connected = true

	Steam.loadItemDefinitions()
	Steam.getAllItems()


func _on_inventory_definition_update(definitions: Array) -> void:
	print("Steam inventory definitions loaded: %s items" % definitions.size())
	# Store definitions for later use
	PlayFabSteam.inventory_item_definitions = definitions


func _on_inventory_result_ready(result: int, inventory_handle: int) -> void:
	print("Steam inventory result ready. Result: %s, Handle: %s" % [result, inventory_handle])

	if result != Steam.RESULT_OK:
		print("Failed to load Steam inventory. Result: %s" % result)
		%LoadingIndicator.hide()
		return

	var items: Array = Steam.getResultItems(inventory_handle)
	print("Steam inventory items loaded: %s items" % items.size())

	_display_inventory_items(items)
	%LoadingIndicator.hide()


func _on_steam_inventory_updated(items: Array) -> void:
	print("Steam inventory updated signal received: %s items" % items.size())
	_clear_inventory()
	_display_inventory_items(items)


func _display_inventory_items(items: Array) -> void:
	if items.is_empty():
		%NoItemsLabel.show()
		return

	%NoItemsLabel.hide()

	# Get item definitions
	var definitions: Array = PlayFabSteam.inventory_item_definitions

	# Create a dictionary for quick lookup of definitions by ID
	var definitions_dict: Dictionary = {}
	for definition in definitions:
		var def_id = definition.get("itemdefid", 0)
		definitions_dict[def_id] = definition

	# Display each item
	for item in items:
		var definition_id = item.get("definition", 0)
		var item_definition: Dictionary = definitions_dict.get(definition_id, {})

		var card: SteamItemCard = card_scene.instantiate()
		card.reset_steam_item(item, item_definition)
		%ItemCardGridContainer.add_child(card)


func _clear_inventory() -> void:
	for child in %ItemCardGridContainer.get_children():
		%ItemCardGridContainer.remove_child(child)
		child.queue_free()


func _on_back_button_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/Economy.tscn")


func _on_refresh_button_pressed() -> void:
	_load_steam_inventory()
