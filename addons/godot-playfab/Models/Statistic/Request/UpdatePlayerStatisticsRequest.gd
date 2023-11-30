extends JsonSerializable
class_name UpdatePlayerStatisticsRequest

# Statistics to be updated with the provided values
var Statistics: StatisticUpdateCollection

# The optional custom tags associated with the request (e.g. build number, external trace identifiers, etc.).
var CustomTags: Dictionary


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"#
		"Statistics":
			return "StatisticUpdateCollection"
		_:
			pass

	# call the parent method that will print an error and return an empty String
	return super._get_type_for_property(property_name)

