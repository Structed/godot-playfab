extends JsonSerializable
class_name SearchItemsResponse

## An opaque token used to retrieve the next page of items, if any are available.
var ContinuationToken: String

## The paginated set of results for the search query.
var Items: Array[CatalogItem]


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
