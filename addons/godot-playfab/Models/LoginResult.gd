extends JsonSerializable
class_name LoginResult

## If LoginTitlePlayerAccountEntity flag is set checked the login request the title_player_account will also be logged in and returned.
var EntityToken: EntityTokenResponse

# Results for requested info.
var InfoResultPayload: GetPlayerCombinedInfoResultPayload

## The time of this user's previous login. If there was no previous login, then it's DateTime.MinValue
var LastLoginTime: float

## True if the account was newly created checked this login.
var NewlyCreated: bool

## Player's unique PlayFabId.
var PlayFabId: String

## Unique token authorizing the user and game at the server level, for the current session.
var SessionTicket: String

## Settings specific to this user.
var SettingsForUser#: UserSettings

#The experimentation treatments for this user at the time of login.
var TreatmentAssignment#: TreatmentAssignment

func _get_type_for_property(property_name: String) -> String:
	match property_name:
		"EntityToken":
			return "EntityTokenResponse"
		"InfoResultPayload":
			return "GetPlayerCombinedInfoResultPayload"
	
	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
