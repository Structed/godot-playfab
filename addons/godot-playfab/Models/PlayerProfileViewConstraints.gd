extends JsonSerializable
class_name PlayerProfileViewConstraints

# Whether to show player's avatar URL. Defaults to false
var ShowAvatarUrl: bool

# Whether to show the banned until time. Defaults to false
var ShowBannedUntil: bool

# Whether to show campaign attributions. Defaults to false
var ShowCampaignAttributions: bool

# Whether to show contact email addresses. Defaults to false
var ShowContactEmailAddresses: bool

# Whether to show the created date. Defaults to false
var ShowCreated: bool

# Whether to show the display name. Defaults to false
var ShowDisplayName: bool

# Whether to show player's experiment variants. Defaults to false
var ShowExperimentVariants: bool

# Whether to show the last login time. Defaults to false
var ShowLastLogin: bool

# Whether to show the linked accounts. Defaults to false
var ShowLinkedAccounts: bool

# Whether to show player's locations. Defaults to false
var ShowLocations: bool

# Whether to show player's membership information. Defaults to false
var ShowMemberships: bool

# Whether to show origination. Defaults to false
var ShowOrigination: bool

# Whether to show push notification registrations. Defaults to false
var ShowPushNotificationRegistrations: bool

# Reserved for future development
var ShowStatistics: bool

# Whether to show tags. Defaults to false
var ShowTags: bool

# Whether to show the total value to date in usd. Defaults to false
var ShowTotalValueToDateInUsd: bool

# Whether to show the values to date. Defaults to false
var ShowValuesToDate: bool

func show_all():
	ShowAvatarUrl = true
	ShowBannedUntil = true
	ShowCampaignAttributions = true
	ShowContactEmailAddresses = true
	ShowCreated = true
	ShowDisplayName = true
	ShowExperimentVariants = true
	ShowLastLogin = true
	ShowLinkedAccounts = true
	ShowLocations = true
	ShowMemberships = true
	ShowOrigination = true
	ShowPushNotificationRegistrations = true
	ShowStatistics = true
	ShowTags = true
	ShowTotalValueToDateInUsd = true
	ShowValuesToDate = true
