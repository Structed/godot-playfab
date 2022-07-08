extends JsonSerializable
class_name GetPlayerStatisticVersionsRequest

# The optional custom tags associated with the request (e.g. build number, external trace identifiers, etc.).
var CustomTags: Dictionary

# unique name of the statistic
var StatisticName: String


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return ._get_type_for_property(property_name)

