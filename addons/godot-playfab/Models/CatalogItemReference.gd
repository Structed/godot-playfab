extends JsonSerializable
class_name CatalogItemReference

## The amount of the catalog item.
var Amount: float

## The unique ID of the catalog item.
var Id: String

## The prices the catalog item can be purchased for.
var PriceOptions: CatalogPriceOptions


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

