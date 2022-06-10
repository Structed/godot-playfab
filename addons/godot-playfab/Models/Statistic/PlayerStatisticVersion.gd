extends JsonSerializable
class_name PlayerStatisticVersion

# time when the statistic version became active
var ActivationTime: String

# time when the statistic version became inactive due to statistic version incrementing
var DeactivationTime: String

# time at which the statistic version was scheduled to become active, based on the configured ResetInterval
var ScheduledActivationTime: String

# time at which the statistic version was scheduled to become inactive, based on the configured ResetInterval
var ScheduledDeactivationTime: String

# name of the statistic when the version became active
var StatisticName: String

# version of the statistic
var Version: int


# @visibility: private
func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return ._get_type_for_property(property_name)

