extends JsonSerializable
class_name GetLeaderboardResult

# Ordered listing of users and their positions in the requested leaderboard.
var Leaderboard: PlayerLeaderboardEntryCollection

# The time the next scheduled reset will occur. Null if the leaderboard does not reset on a schedule.
var NextReset: String

# The version of the leaderboard returned.
var Version: int


func _get_type_for_property(property_name: String) -> String:
	match property_name:
		"Leaderboard":
			return "PlayerLeaderboardEntryCollection"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return ._get_type_for_property(property_name)

