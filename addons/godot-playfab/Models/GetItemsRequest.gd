extends JsonSerializable
## Request to get items from the catalog.
## @tutorial(PlayFab REST API Docs):https://learn.microsoft.com/en-us/rest/api/playfab/economy/catalog/get-items?view=playfab-rest
class_name GetItemsRequest

## List of item alternate IDs.
var AlternateIds: Array[CatalogAlternateId]

## The optional custom tags associated with the request (e.g. build number, external trace identifiers, etc.).
var CustomTags: Dictionary

## The entity to perform this action on.
var Entity: EntityKey

## List of Item Ids.
var Ids: Array[String]


func _init():
	pass


func _get_type_for_property(property_name: String) -> String:
	match property_name:
		"Entity":
			return "EntityKey"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

