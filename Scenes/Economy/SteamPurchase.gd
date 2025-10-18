extends Control

## Steam Purchase Scene - Demonstrates the Steam purchase flow with PlayFab

@onready var status_label: Label = %StatusLabel
@onready var purchase_button: Button = %PurchaseButton
@onready var item_name_label: Label = %ItemNameLabel
@onready var price_label: Label = %PriceLabel

var steam_purchase_manager: PlayFabSteamPurchase
var test_item_id: String = "1"
var test_price: int = 25	# In cents
var _steam_available: bool = false

func _ready() -> void:
	# Check if Steam is available
	_steam_available = ClassDB.can_instantiate("Steam")
	if not _steam_available:
		_show_error("Steam is not available. GodotSteam plugin required.")
		return

	# Now that we know Steam is available, we can safely access it
	if not Steam.isSteamRunning():
		_show_error("Steam client is not running!")
		return

	# Initialize the purchase manager
	steam_purchase_manager = PlayFabSteamPurchase.new()
	add_child(steam_purchase_manager)

	# Connect signals
	steam_purchase_manager.purchase_started.connect(_on_purchase_started)
	steam_purchase_manager.purchase_authorized.connect(_on_purchase_authorized)
	steam_purchase_manager.purchase_completed.connect(_on_purchase_completed)
	steam_purchase_manager.purchase_failed.connect(_on_purchase_failed)

	# Setup UI
	_update_ui()

func _update_ui() -> void:
	item_name_label.text = "Gobuck 25"
	var float_price: float = (test_price as float) / 100
	price_label.text = "$%.2f" % float_price
	status_label.text = "Ready to purchase"
	purchase_button.disabled = false

func _on_purchase_button_pressed() -> void:
	if steam_purchase_manager == null:
		_show_error("Purchase manager not initialized")
		return

	status_label.text = "Initiating purchase..."
	purchase_button.disabled = true

	# Start the purchase flow
	steam_purchase_manager.purchase_item(
		test_item_id,
		1,  # quantity
		test_price,
		"Test item purchase from Godot"
	)

func _on_purchase_started(order_id: String) -> void:
	print("Purchase started: %s" % order_id)
	status_label.text = "Order created. Waiting for Steam authorization...\nOrderID: %s" % order_id
	status_label.add_theme_color_override("font_color", Color.YELLOW)

func _on_purchase_authorized(order_id: String) -> void:
	print("Purchase authorized: %s" % order_id)
	status_label.text = "Purchase authorized! Finalizing with backend..."
	status_label.add_theme_color_override("font_color", Color.CYAN)

func _on_purchase_completed(order_id: String, granted_items: Array) -> void:
	print("Purchase completed: %s, Items: %s" % [order_id, granted_items])
	status_label.text = "Purchase completed successfully!\nItems granted: %s" % str(granted_items)
	status_label.add_theme_color_override("font_color", Color.GREEN)
	purchase_button.disabled = false

func _on_purchase_failed(error_message: String) -> void:
	print("Purchase failed: %s" % error_message)
	_show_error("Purchase failed: %s" % error_message)
	purchase_button.disabled = false

func _show_error(message: String) -> void:
	status_label.text = message
	status_label.add_theme_color_override("font_color", Color.RED)

func _on_back_button_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/Economy.tscn")
