extends JsonSerializable
class_name PlayerLeaderboardEntry

# Title-specific display name of the user for this leaderboard entry.
var DisplayName: String

# PlayFab unique identifier of the user for this leaderboard entry.
var PlayFabId: String

# User's overall position in the leaderboard.
var Position: int

# The profile of the user, if requested.
var Profile: Dictionary # TODO: PlayerProfileModel

# Specific value of the user's statistic.
var StatValue: int


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	# call the parent method that will print an error and return an empty String
	return super._get_type_for_property(property_name)

