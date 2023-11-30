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

	# call the parent method that will print an error and return an empty String
	return super._get_type_for_property(property_name)

