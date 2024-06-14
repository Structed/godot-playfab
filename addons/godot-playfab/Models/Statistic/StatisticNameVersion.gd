extends JsonSerializable
class_name StatisticNameVersion

# unique name of the statistic
var StatisticName: String

# the version of the statistic to be returned
var Version: float


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return ._get_type_for_property(property_name)

