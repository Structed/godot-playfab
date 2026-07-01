extends JsonSerializable
class_name InventoryAlternateId

## Type of the alternate ID. 
var Type: String 


## Value of the alternate ID. 
var Value: String 



func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

