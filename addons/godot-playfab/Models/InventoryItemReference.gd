extends JsonSerializable
class_name InventoryItemReference

## The inventory item alternate id the request applies to.
var AlternateId: InventoryAlternateId


## The inventory item id the request applies to.
var Id: String


## The inventory stack id the request should redeem to. (Default="default")
var StackId: String



func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
