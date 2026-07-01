extends JsonSerializable
## Response of [Catalog]
## @tutorial https://learn.microsoft.com/en-us/rest/api/playfab/economy/catalog/get-items?view=playfab-rest#getitemsresponse
class_name GetItemsResponse

## Metadata of set of items.
var Items: Array[CatalogItem]


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
