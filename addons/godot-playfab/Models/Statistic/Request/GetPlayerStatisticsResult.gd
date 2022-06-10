extends JsonSerializable
class_name GetPlayerStatisticsResult

# User statistics for the requested user.
var Statistics: StatisticValueCollection


func _get_type_for_property(property_name: String) -> String:
	match property_name:
		"Statistics":
			return "StatisticValueCollection"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return ._get_type_for_property(property_name)

