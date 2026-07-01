extends JsonSerializable
class_name GetPlayerStatisticsRequest

# The optional custom tags associated with the request (e.g. build number, external trace identifiers, etc.).
var CustomTags: Dictionary

# statistics to return, if StatisticNames is not set (only statistics which have a version matching that provided will be returned)
var StatisticNameVersions: Array

# statistics to return (current version will be returned for each)
# String[]
var StatisticNames: Array


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		"StatisticNameVersions":
			return "StatisticNameVersionsCollection"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return ._get_type_for_property(property_name)

