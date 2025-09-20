@icon("res://addons/godot-playfab/icon.png")

extends PlayFab
class_name PlayFabCatalog


## Retrieves items from the public catalog. Up to 50 items can be returned at once.
## GetItems does not work off a cache of the Catalog and should be used when trying to get recent item updates.
## However, please note that item references data is cached and may take a few moments for changes to propagate.
## @tutorial: https://docs.microsoft.com/gaming/playfab/features/economy/catalog/get-items
## @Visibility: Public
## @param request_data: Catalog_GetItemsRequest - Request object, optional
## @callback: Callable (optional) - Optional callback function, receiving a [GetItemsResponse].
func get_items(request_data: Catalog_GetItemsRequest = Catalog_GetItemsRequest.new(), callback: Callable = func(): pass):
	_post_with_entity_auth(request_data, "/Catalog/GetItems", callback)
