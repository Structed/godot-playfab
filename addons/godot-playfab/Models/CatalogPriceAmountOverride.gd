extends JsonSerializable
class_name CatalogPriceAmountOverride

## The exact value that should be utilized in the override.
var FixedValue: float

## The id of the item this override should utilize.
var ItemId: String

## The multiplier that will be applied to the base Catalog value to determine what value should be utilized in the override.
var Multiplier: int


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

