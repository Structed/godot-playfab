extends JsonSerializable
class_name JsonSerializableSubPropImpl

var sub_prop: SubProp

func _get_type_for_property(property_name: String) -> String:
	match property_name:
		"sub_prop":
			return "SubProp"

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
