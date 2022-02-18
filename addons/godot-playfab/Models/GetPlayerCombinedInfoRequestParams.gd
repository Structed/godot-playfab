extends JsonSerializable
class_name GetPlayerCombinedInfoRequestParams

# Whether to get character inventories. Defaults to false.
var GetCharacterInventories: bool

# Whether to get the list of characters. Defaults to false.
var GetCharacterList: bool

# Whether to get player profile. Defaults to false. Has no effect for a new player.
var GetPlayerProfile: bool

# Whether to get player statistics. Defaults to false.
var GetPlayerStatistics: bool

# Whether to get title data. Defaults to false.
var GetTitleData: bool

# Whether to get the player's account Info. Defaults to false
var GetUserAccountInfo: bool

# Whether to get the player's custom data. Defaults to false
var GetUserData: bool

# Whether to get the player's inventory. Defaults to false
var GetUserInventory: bool

# Whether to get the player's read only data. Defaults to false
var GetUserReadOnlyData: bool

# Whether to get the player's virtual currency balances. Defaults to false
var GetUserVirtualCurrency: bool

# Specific statistics to retrieve. Leave null to get all keys. Has no effect if GetPlayerStatistics is false
var PlayerStatisticNames: Array

# Specifies the properties to return from the player profile. Defaults to returning the player's display name.
var ProfileConstraints: PlayerProfileViewConstraints

# Specific keys to search for in the custom data. Leave null to get all keys. Has no effect if GetTitleData is false
var TitleDataKeys: Array

# Specific keys to search for in the custom data. Leave null to get all keys. Has no effect if GetUserData is false
var UserDataKeys: Array

# Specific keys to search for in the custom data. Leave null to get all keys. Has no effect if GetUserReadOnlyData is false
var UserReadOnlyDataKeys: Array

func show_all():
	GetCharacterInventories = true
	GetCharacterList = true
	GetPlayerProfile = true
	GetPlayerStatistics = true
	GetTitleData = true
	GetUserAccountInfo = true
	GetUserData = true
	GetUserInventory = true
	GetUserReadOnlyData = true
	GetUserVirtualCurrency = true
	
#	ProfileConstraints = ProfileConstraints.new()
#	ProfileConstraints.show_all()
