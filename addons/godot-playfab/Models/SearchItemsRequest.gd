extends JsonSerializable
class_name SearchItemsRequest

## Number of items to retrieve. This value is optional. Maximum page size is 50. Default value is 10.
var Count: int

## An opaque token used to retrieve the next page of items, if any are available.
var ContinuationToken: String

## The optional custom tags associated with the request (e.g. build number, external trace identifiers, etc.).
var CustomTags: Dictionary

## The entity to perform this action on.
var Entity: EntityKey

## An OData filter used to refine the search query (For example: "type eq 'ugc'"). More info about Filter Complexity limits can be found here: https://learn.microsoft.com/en-us/gaming/playfab/features/economy-v2/catalog/search#limits
var Filter: String

## The locale to be returned in the result.
var Language: String

## An OData orderBy used to order the results of the search query. For example: "rating/average asc"
var OrderBy: String

## The text to search for.
var Search: String

## An OData select query option used to augment the search results. If not defined, the default search result metadata will be returned.
var Select: String

## The store to restrict the search request to.
var Store: StoreReference


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		"Entity":
			return "EntityKey"
		"Store":
			return "StoreReference"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
