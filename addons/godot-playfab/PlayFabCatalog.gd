@icon("res://addons/godot-playfab/icon.png")

extends PlayFab
class_name PlayFabCatalog


## Retrieves items from the public catalog. Up to 50 items can be returned at once.
## GetItems does not work off a cache of the Catalog and should be used when trying to get recent item updates.
## However, please note that item references data is cached and may take a few moments for changes to propagate.
## Callback receives a [GetItemsResponse]
## @tutorial(Request Documentation): https://docs.microsoft.com/gaming/playfab/features/economy/catalog/get-items
func get_items(request_data: GetItemsRequest = GetItemsRequest.new(), callback: Callable = func(): pass):
	_post_with_entity_auth(request_data, "/Catalog/GetItems", callback)

## Executes a search against the public catalog using the provided search parameters
## and returns a set of paginated results.
## SearchItems uses a cache of the catalog with item updates taking up to a few minutes to propagate.
## You should use the GetItem API for when trying to immediately get recent item updates.
## Callback receives a [SearchItemsResponse] of items which can be paginated with a continuation token.
## More information about the Search API can be found here:
## @tutorial(Search API): https://learn.microsoft.com/en-us/gaming/playfab/features/economy-v2/catalog/search
## @tutorial(Request Documentation): https://docs.microsoft.com/gaming/playfab/features/economy/catalog/get-items
func search_items(request_data: SearchItemsRequest = SearchItemsRequest.new(), callback: Callable = func(): pass):
	_post_with_entity_auth(request_data, "/Catalog/SearchItems", callback)
	
