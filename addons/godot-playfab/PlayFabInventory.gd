@icon("res://addons/godot-playfab/icon.png")

extends PlayFab
class_name PlayFabInventory

const PAGE_SIZE := 50
const TURBOLOAD_PAGE_SIZE := 10000




## Get current inventory items.
## Callback receives a [GetInventoryItemsResponse]
## @tutorial(Request Documentation): https://learn.microsoft.com/en-us/rest/api/playfab/economy/inventory/get-inventory-items?view=playfab-rest
func get_inventory_items(request_data: GetInventoryItemsRequest = GetInventoryItemsRequest.new(), callback: Callable = func(): pass):
	_post_with_entity_auth(request_data, "/Inventory/GetInventoryItems", callback)
