extends JsonSerializable
class_name StatisticUpdate

# string
var StatisticName: String

# statistic value for the player
var Value: int

# for updates to an existing statistic value for a player, the version of the statistic when it was loaded. Null when setting the statistic value for the first time.
var Version: int


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return ._get_type_for_property(property_name)

