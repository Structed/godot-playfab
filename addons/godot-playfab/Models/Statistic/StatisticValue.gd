extends JsonSerializable
class_name StatisticValue

# unique name of the statistic
var StatisticName: String

# statistic value for the player
var Value: float

# for updates to an existing statistic value for a player, the version of the statistic when it was loaded
var Version: float


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	# call the parent method that will print an error and return an empty String
	return super._get_type_for_property(property_name)

