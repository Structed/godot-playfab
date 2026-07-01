extends JsonSerializable
class_name CatalogPriceAmount

## The amount of the price.
var Amount: float

## The Item Id of the price.
var ItemId: String


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
