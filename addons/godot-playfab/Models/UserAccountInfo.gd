extends JsonSerializable
class_name UserAccountInfo

# User Android device information, if an Android device has been linked
var AndroidDeviceInfo#: UserAndroidDeviceInfo

# Sign in with Apple account information, if an Apple account has been linked
var AppleAccountInfo#: UserAppleIdInfo

# Timestamp indicating when the user account was created
var Created: String

# Custom ID information, if a custom ID has been assigned
var CustomIdInfo#: UserCustomIdInfo

# User Facebook information, if a Facebook account has been linked
var FacebookInfo#: UserFacebookInfo

# Facebook Instant Games account information, if a Facebook Instant Games account has been linked
var FacebookInstantGamesIdInfo#: UserFacebookInstantGamesIdInfo

# User Gamecenter information, if a Gamecenter account has been linked
var GameCenterInfo#: UserGameCenterInfo

# User Google account information, if a Google account has been linked
var GoogleInfo#: UserGoogleInfo

# User iOS device information, if an iOS device has been linked
var IosDeviceInfo#: UserIosDeviceInfo

# User Kongregate account information, if a Kongregate account has been linked
var KongregateInfo#: UserKongregateInfo

# Nintendo Switch account information, if a Nintendo Switch account has been linked
var NintendoSwitchAccountInfo#: UserNintendoSwitchAccountIdInfo

# Nintendo Switch device information, if a Nintendo Switch device has been linked
var NintendoSwitchDeviceIdInfo#: UserNintendoSwitchDeviceIdInfo

# OpenID Connect information, if any OpenID Connect accounts have been linked
var OpenIdInfo: Array

# Unique identifier for the user account
var PlayFabId: String

# Personal information for the user which is considered more sensitive
var PrivateInfo#: UserPrivateAccountInfo

# User PSN account information, if a PSN account has been linked
var PsnInfo#: UserPsnInfo

# User Steam information, if a Steam account has been linked
var SteamInfo#: UserSteamInfo

# Title-specific information for the user account
var TitleInfo: UserTitleInfo

# User Twitch account information, if a Twitch account has been linked
var TwitchInfo#: UserTwitchInfo

# User account name in the PlayFab service
var Username: String

# User XBox account information, if a XBox account has been linked
var XboxInfo#: UserXboxInfo

func _get_type_for_property(property_name: String) -> String:
	match property_name:
		"TitleInfo":
			return "UserTitleInfo"
	
	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
