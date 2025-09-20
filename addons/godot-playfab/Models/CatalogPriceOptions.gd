extends JsonSerializable
class_name CatalogPriceOptions

## Prices of the catalog item. An item can have up to 15 prices
var Prices: Array[CatalogPrice]


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

