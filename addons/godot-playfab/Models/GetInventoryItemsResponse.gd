extends JsonSerializable
class_name GetInventoryItemsResponse

## An opaque token used to retrieve the next page of items, if any are available.
var ContinuationToken: String


## ETags are used for concurrency checking when updating resources. More information about using ETags can be found here: https://learn.microsoft.com/en-us/gaming/playfab/features/economy-v2/catalog/etags
var ETag: String


## The requested inventory items.
var Items: Array[InventoryItem]



func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

