extends JsonSerializable
class_name FilterOptions

## The OData filter utilized. Mutually exclusive with 'IncludeAllItems'. More info about Filter Complexity limits can be found here: https://learn.microsoft.com/en-us/gaming/playfab/features/economy-v2/catalog/search#limits
var Filter: String

## The flag that overrides the filter and allows for returning all catalog items. Mutually exclusive with 'Filter'.
var IncludeAllItems: bool


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

