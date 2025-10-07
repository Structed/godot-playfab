@icon("res://addons/godot-playfab/icon.png")

extends PlayFab
class_name PlayFabCatalog

signal search_complete
signal search_currency_complete

const PAGE_SIZE := 50
const FULL_CATALOG_FETCH_TIMEOUT := 3600 # seconds

var _catalog: Dictionary[String, CatalogItem] = {}          # item_id -> ShopItem
var _last_catalog_fetch_time: int = 0
var _fetching_catalog := false
var _has_full_catalog := false

# Search for all items using PlayFabManager.catalog.search_items() with pagination
var _search_results : Dictionary[String, CatalogItem] = {}
var continuation_token := ""

## Returns the cached catalog, fetching it if it's older than 5 minutes.
func get_catalog() -> Dictionary[String, CatalogItem]:
	if _last_catalog_fetch_time == 0 or Time.get_unix_time_from_system() - _last_catalog_fetch_time > FULL_CATALOG_FETCH_TIMEOUT:
		fetch_catalog()
	return _catalog

## Fetches the entire catalog with pagination.
## Emits [search_complete] when done.
func fetch_catalog() -> void:
	if _fetching_catalog:
		return
	_fetching_catalog = true
	_last_catalog_fetch_time = Time.get_unix_time_from_system()
	_search_results.clear()
	_fetch_catalog_page()

## Internal function to fetch a page of search results.
func _fetch_catalog_page(token: String = "") -> void:
	var request_data: SearchItemsRequest = SearchItemsRequest.new()
	request_data.Search = ""
#	request_data.Filter = "type ne 'currency'"
#	request_data.Filter  "tags/any(t:t eq 'desert') and contentType eq 'gameitem'"
	request_data.OrderBy = "CreationDate asc"
	request_data.ContinuationToken = token
	request_data.Count = PAGE_SIZE
#	request_data.Language = _locale

	if token != "":
		request_data.ContinuationToken = token

	search_items(request_data, _on_search_page_ok)

## Searches for currencies.
## Not paginated!
## Emits [search_currency_complete] when done.
func search_currency(callback: Callable = func(): pass) -> void:
	var request_data: SearchItemsRequest = SearchItemsRequest.new()
	request_data.Search = ""
	request_data.Filter = "type eq 'currency'"
	request_data.OrderBy = "CreationDate asc"
	request_data.Count = PAGE_SIZE

	search_items(request_data, _on_search_currency_complete)

## Internal callback for search_currency
func _on_search_currency_complete(result: Dictionary) -> void:
	var res = SearchItemsResponse.new()
	res.from_dict(result.data, res)
	var results_items : Dictionary[String, CatalogItem] = {}
	for item: CatalogItem in res.Items:
		results_items[item.Id] = item

	search_currency_complete.emit(results_items)


func _on_search_page_ok(result: Dictionary) -> void:
	var res = SearchItemsResponse.new()
	res.from_dict(result.data, res)
	for item: CatalogItem in res.Items:
		_search_results[item.Id] = item

	var next_token: String = res.ContinuationToken
	if next_token != null and next_token != "":
		_fetch_catalog_page(next_token)
	else:
		_fetching_catalog = false
		_has_full_catalog = true
		_catalog.clear()
		_catalog = _search_results
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
