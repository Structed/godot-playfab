extends JsonSerializable
class_name GetTitleDataResult

# a dictionary object of key / value pairs
var Data: Dictionary


func _get_type_for_property(property_name: String) -> String:
	match property_name:
		_:
			pass
	
	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
