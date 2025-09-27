@icon("res://addons/godot-playfab/icon.png")

extends PlayFab
class_name PlayFabCatalog

signal search_complete

const PAGE_SIZE := 50

var _catalog: Dictionary[String, Dictionary] = {}          # item_id -> ShopItem
var _last_catalog_fetch_time: float = 0
var _fetching_catalog := false
var _has_full_catalog := false

# Search for all items using PlayFabManager.catalog.search_items() with pagination
var search_results : Dictionary[String, CatalogItem] = {}
var continuation_token := ""


func _search_all_items():
	search_results.clear()
	_search_page("")

func _search_page(token: String) -> void:
	var request_data: SearchItemsRequest = SearchItemsRequest.new()
	request_data.Search = ""
#	request_data.Filter  "tags/any(t:t eq 'desert') and contentType eq 'gameitem'"
	request_data.OrderBy = "CreationDate asc"
	request_data.ContinuationToken = token
	request_data.Count = PAGE_SIZE
#	request_data.Language = _locale

	if token != "":
		request_data.ContinuationToken = token

	search_items(request_data, _on_search_page_ok)

func _on_search_page_ok(result: Dictionary) -> void:
	var res = SearchItemsResponse.new()
	res.from_dict(result.data, res)
	for item: CatalogItem in res.Items:
		search_results[item.Id] = item

	var next_token: String = res.ContinuationToken
	if next_token != null and next_token != "":
		_search_page(next_token)
	else:
		search_complete.emit()




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
