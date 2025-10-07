@icon("res://addons/godot-playfab/icon.png")

extends PlayFab
class_name PlayFabInventory

const PAGE_SIZE := 50
const TURBOLOAD_PAGE_SIZE := 10000


var _inventory_items: Dictionary[String, InventoryItem] = {}	# item_id -> ShopItem
var _last_inventory_fetch_time: int = 0
var _fetching_inventory := false
var _has_full_inventory := false


func _ready():
	PlayFabManager.playfab_initialized.connect(func():
		turboload_inventory()
	)


## Get current inventory items stored locally.
## Returns a dictionary of InventoryItem objects, keyed by their item IDs.
func get_inventory() -> Dictionary[String, InventoryItem]:
	return _inventory_items

## Get current inventory items and store them locally.
## Callback receives a [GetInventoryItemsResponse]
## @tutorial: https://learn.microsoft.com/en-us/gaming/playfab/economy-monetization/economy-v2/inventory/turboloading
func turboload_inventory(callback: Callable = func(): pass) -> void:
	if _fetching_inventory:
		callback.call(GetInventoryItemsResponse.new())
		return

	_fetching_inventory = true

	var request_data: GetInventoryItemsRequest = GetInventoryItemsRequest.new()
	request_data.Count = TURBOLOAD_PAGE_SIZE
	get_inventory_items(request_data, func(result: GetInventoryItemsResponse) -> void:
		_inventory_items.clear()
		for item in result.Items:
			_inventory_items[item.Id] = item

		_fetching_inventory = false
		_has_full_inventory = true
		_last_inventory_fetch_time = Time.get_unix_time_from_system()

		if callback.is_valid():
			callback.call()
	)



## Get current inventory items.
## Callback receives a [GetInventoryItemsResponse]
## @tutorial(Request Documentation): https://learn.microsoft.com/en-us/rest/api/playfab/economy/inventory/get-inventory-items?view=playfab-rest
func get_inventory_items(request_data: GetInventoryItemsRequest = GetInventoryItemsRequest.new(), callback: Callable = func(): pass):
	_post_with_entity_auth(request_data, "/Inventory/GetInventoryItems", func(result: Dictionary) -> void:
		var res = GetInventoryItemsResponse.new()
		res.from_dict(result.data, res)
		callback.call(res)
	)
