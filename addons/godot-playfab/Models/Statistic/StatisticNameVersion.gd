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

	# call the parent method that will print an error and return an empty String
	return super._get_type_for_property(property_name)

