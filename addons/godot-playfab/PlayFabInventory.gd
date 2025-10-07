@icon("res://addons/godot-playfab/icon.png")

extends PlayFab
class_name PlayFabInventory

const PAGE_SIZE := 50
const TURBOLOAD_PAGE_SIZE := 10000


func turboload_inventory(callback: Callable = func(): pass) -> void:
	var request_data: GetInventoryItemsRequest = GetInventoryItemsRequest.new()
	request_data.Count = TURBOLOAD_PAGE_SIZE
	get_inventory_items(request_data, func(result: GetInventoryItemsResponse) -> void:
		callback.call(result)
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
