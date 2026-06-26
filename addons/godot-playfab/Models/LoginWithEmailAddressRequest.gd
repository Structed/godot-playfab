extends JsonSerializable
class_name LoginWithEmailAddressRequest

# https://docs.microsoft.com/en-us/rest/api/playfab/client/authentication/login-with-email-address?view=playfab-rest

# Email address for the account.
var Email: String

# Password for the PlayFab account (6-100 characters)
var Password: String

# Unique identifier for the title, found in the Settings > Game Properties section of the PlayFab developer site when a title has been selected.
var TitleId: String

# The optional custom tags associated with the request (e.g. build number, external trace identifiers, etc.).
var CustomTags: Dictionary #object

# Flags for which pieces of info to return for the user.
var InfoRequestParameters: GetPlayerCombinedInfoRequestParams


func _get_type_for_property(property_name: String) -> String:
	match property_name:
		"InfoRequestParameters":
			return "GetPlayerCombinedInfoRequestParams"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
