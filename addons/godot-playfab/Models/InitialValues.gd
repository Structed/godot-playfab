extends JsonSerializable
class_name InitialValues

## Game specific properties for display purposes. The Display Properties field has a 1000 byte limit. 
var DisplayProperties: Dictionary[String, Variant] 



func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

