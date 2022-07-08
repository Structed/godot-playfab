extends JsonSerializable
class_name GetPlayerStatisticVersionsResult

# version change history of the statistic
var StatisticVersions: PlayerStatisticVersionCollection


func _get_type_for_property(property_name: String) -> String:
	match property_name:
		"StatisticVersions":
			return "PlayerStatisticVersionCollection"
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return ._get_type_for_property(property_name)

