@icon("res://addons/godot-playfab/icon.png")

extends Node
class_name PlayFabSteamPurchase

## Manages Steam purchases integrated with PlayFab Economy v2
## Implements the purchase flow: Client -> Azure Backend -> Steam -> PlayFab

signal purchase_started(order_id: String)
signal purchase_authorized(order_id: String)
signal purchase_completed(order_id: String, granted_items: Array)
signal purchase_failed(error_message: String)

const BACKEND_URL_SETTING := "playfab/backend_url"

var _backend_url: String = ""
var _http_request: HTTPRequest
var _pending_order_id: String = ""
var _pending_item_id: String = ""
var _steam_available: bool = false

func _init() -> void:
	_steam_available = ClassDB.can_instantiate("Steam")
	if not _steam_available:
		push_error("Steam class is not available! GodotSteam plugin required.")
		return

	if not Steam.isSteamRunning():
		push_warning("Steam client is not running!")
		return

	# Get backend URL from project settings
	if ProjectSettings.has_setting(BACKEND_URL_SETTING):
		_backend_url = ProjectSettings.get_setting(BACKEND_URL_SETTING)
	else:
		push_warning("Backend URL not set in project settings: %s" % BACKEND_URL_SETTING)
		# Default to local development
		_backend_url = "http://localhost:7071/api"

func _ready() -> void:
	if not _steam_available:
		return

	_http_request = HTTPRequest.new()
	add_child(_http_request)
	_http_request.request_completed.connect(_on_http_request_completed)

	# Connect to Steam signals
	Steam.microtransaction_auth_response.connect(_on_microtxn_authorization_response)

func _process(_delta: float) -> void:
	if _steam_available:
		Steam.run_callbacks()

## Initiates a Steam purchase
## @param item_id: The catalog item ID to purchase
## @param quantity: Number of items to purchase
## @param price: Price in the configured currency (e.g., USD), in cents
## @param description: Optional description for the purchase
func purchase_item(item_id: String, quantity: int, price: int, description: String = "") -> void:
	if not _steam_available:
		purchase_failed.emit("Steam is not available")
		return

	if not Steam.isSteamRunning():
		purchase_failed.emit("Steam client is not running")
		return

	var steam_id := str(Steam.getSteamID())
	if steam_id.is_empty() or steam_id == "0":
		purchase_failed.emit("Invalid Steam ID")
		return

	_pending_item_id = item_id
	var order_id: String = str(Time.get_ticks_msec())

	# Step 1: Request backend to create Steam order
	var request_data := {
		"steamId": steam_id,
		"orderId": order_id,
		"itemId": item_id,
		"quantity": quantity,
		"price": price,
		"description": description if description != "" else "Purchase of %s" % item_id
	}

	var json := JSON.stringify(request_data)
	var headers := ["Content-Type: application/json"]
	var url := "%s/CreateSteamOrder" % _backend_url

	print("Requesting Steam order creation: %s" % url)
	var error := _http_request.request(url, headers, HTTPClient.METHOD_POST, json)

	if error != OK:
		purchase_failed.emit("Failed to send order request: %s" % error)

## Called when HTTP request completes
func _on_http_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if _result != HTTPRequest.RESULT_SUCCESS:
		purchase_failed.emit("HTTP request failed: %s" % _result)
		return

	var json := JSON.new()
	var parse_result := json.parse(body.get_string_from_utf8())

	if parse_result != OK:
		purchase_failed.emit("Failed to parse response")
		return

	var response := json.data

	if response_code == 200:
		_handle_create_order_response(response)
	else:
		var error_msg: String = response.get("error", "Unknown error")
		purchase_failed.emit("Server error: %s" % error_msg)

## Handles the CreateSteamOrder response
func _handle_create_order_response(response: Dictionary) -> void:
	if not response.has("OrderId"):
		purchase_failed.emit("Invalid response from server")
		return

	_pending_order_id = response.OrderId
	var steam_url := response.get("SteamUrl", "")

	print("Steam order created: %s" % _pending_order_id)
	purchase_started.emit(_pending_order_id)

	# Step 2: Open Steam overlay to complete purchase
	# Steam will show the payment dialog
	if steam_url != "":
		# If Steam provides a URL, we could open it (though typically handled by Steam overlay)
		pass

	# The Steam overlay should open automatically when the MicroTxn is initiated
	# Wait for Steam callback...

## Called when Steam sends authorization response
func _on_microtxn_authorization_response(_app_id: int, order_id: int, authorized: bool) -> void:
	var order_id_str := str(order_id)

	print("Steam MicroTxn authorization response - OrderID: %s, Authorized: %s" % [order_id_str, authorized])

	if not authorized:
		purchase_failed.emit("Purchase was not authorized by Steam")
		_pending_order_id = ""
		_pending_item_id = ""
		return

	purchase_authorized.emit(order_id_str)

	# Step 3: Notify backend that order was authorized
	_finalize_purchase(order_id_str)

## Finalizes the purchase with the backend
func _finalize_purchase(order_id: String) -> void:
	if not _steam_available:
		purchase_failed.emit("Steam is not available")
		return

	var steam_id := str(Steam.getSteamID())

	var request_data := {
		"orderId": order_id,
		"steamId": steam_id,
		"itemId": _pending_item_id
	}

	var json := JSON.stringify(request_data)
	var headers := ["Content-Type: application/json"]
	var url := "%s/FinalizeSteamPurchase" % _backend_url

	print("Finalizing Steam purchase: %s" % url)

	# Disconnect the previous handler and connect a new one for finalization
	if _http_request.request_completed.is_connected(_on_http_request_completed):
		_http_request.request_completed.disconnect(_on_http_request_completed)
	_http_request.request_completed.connect(_on_finalize_request_completed)

	var error := _http_request.request(url, headers, HTTPClient.METHOD_POST, json)

	if error != OK:
		purchase_failed.emit("Failed to send finalization request: %s" % error)

## Called when finalization HTTP request completes
func _on_finalize_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	# Reconnect the original handler
	if _http_request.request_completed.is_connected(_on_finalize_request_completed):
		_http_request.request_completed.disconnect(_on_finalize_request_completed)
	_http_request.request_completed.connect(_on_http_request_completed)

	if _result != HTTPRequest.RESULT_SUCCESS:
		purchase_failed.emit("HTTP request failed during finalization: %s" % _result)
		return

	var json := JSON.new()
	var parse_result := json.parse(body.get_string_from_utf8())

	if parse_result != OK:
		purchase_failed.emit("Failed to parse finalization response")
		return

	var response := json.data

	if response_code == 200:
		_handle_finalize_response(response)
	else:
		var error_msg: String = response.get("Error", "Unknown error")
		purchase_failed.emit("Finalization failed: %s" % error_msg)

## Handles the FinalizeSteamPurchase response
func _handle_finalize_response(response: Dictionary) -> void:
	if not response.get("Success", false):
		purchase_failed.emit("Purchase finalization was not successful")
		return

	var order_id := response.get("OrderId", "")
	var granted_items := response.get("GrantedItems", [])
	var transaction_id := response.get("TransactionId", "")

	print("Purchase completed! OrderID: %s, TransactionID: %s, Items: %s" % [order_id, transaction_id, granted_items])

	purchase_completed.emit(order_id, granted_items)

	# Refresh PlayFab inventory to show new items
	if PlayFabManager.inventory:
		PlayFabManager.inventory.turboload_inventory()

	_pending_order_id = ""
	_pending_item_id = ""
