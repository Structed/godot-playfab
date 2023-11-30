extends JsonSerializable
class_name GetLeaderboardRequest

# Position in the leaderboard to start this listing (defaults to the first entry).
var StartPosition: int = 0

# Statistic used to rank players for this leaderboard.
var StatisticName: String

# The optional custom tags associated with the request (e.g. build number, external trace identifiers, etc.).
var CustomTags: Dictionary

# Maximum number of entries to retrieve. Default 10, maximum 100.
var MaxResultsCount: int

# If non-null, this determines which properties of the resulting player profiles to return. For API calls from the client, only the allowed client profile properties for the title may be requested. These allowed properties are configured in the Game Manager "Client Profile Options" tab in the "Settings" section.
var ProfileConstraints: PlayerProfileViewConstraints

# If set to false, Version is considered null. If true, uses the specified Version
var UseSpecificVersion: bool = true

# The version of the leaderboard to get.
var Version: int


func _get_type_for_property(property_name: String) -> String:
	match property_name:
		"ProfileConstraints":
			return "PlayerProfileViewConstraints"
		_:
			pass
		
	# call the parent method that will print an error and return an empty String
	return super._get_type_for_property(property_name)

