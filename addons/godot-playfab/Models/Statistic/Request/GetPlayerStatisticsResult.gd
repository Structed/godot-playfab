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

	# call the parent method that will print an error and return an empty String
	return super._get_type_for_property(property_name)

