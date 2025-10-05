extends JsonSerializable
class_name GetInventoryItemsRequest

## Number of items to retrieve. This value is optional. Maximum page size is 50. The default value is 10
## REQUIRED: true
var Count: float


## The id of the entity's collection to perform this action on. (Default="default")
var CollectionId: String


## An opaque token used to retrieve the next page of items in the inventory, if any are available. Should be null on initial request.
var ContinuationToken: String


## The optional custom tags associated with the request (e.g. build number, external trace identifiers, etc.).
var CustomTags: Dictionary[String, Variant]


## The entity to perform this action on.
var Entity: EntityKey


## OData Filter to refine the items returned. InventoryItem properties 'type', 'id', and 'stackId' can be used in the filter. For example: "type eq 'currency'"
var Filter: String



func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

