extends JsonSerializable
class_name Permissions

## The list of ids of Segments that the a player can be in to purchase from the store. When a value is provided, the player must be in at least one of the segments listed for the purchase to be allowed.
var SegmentIds: Array[String]


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

