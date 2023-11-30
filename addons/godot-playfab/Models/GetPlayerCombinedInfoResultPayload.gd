extends JsonSerializable
class_name GetPlayerCombinedInfoResultPayload

# Account information for the user. This is always retrieved.
var AccountInfo: UserAccountInfo

# Inventories for each character for the user.
var CharacterInventories: Array

# List of characters for the user.
var CharacterList: Array

# The profile of the players. This profile is not guaranteed to be up-to-date. For a new player, this profile will not exist.
var PlayerProfile#: PlayerProfileModel

# List of statistics for this player.
var PlayerStatistics: Array

# Title data for this title.
var TitleData#: object

# User specific custom data.
var UserData#: UserDataRecord

# The version of the UserData that was returned.
var UserDataVersion#: number

# Array of inventory items in the user's current inventory.
var UserInventory: Array

# User specific read-only data.
var UserReadOnlyData#: UserDataRecord

# The version of the Read-Only UserData that was returned.
var UserReadOnlyDataVersion#: number

# Dictionary of virtual currency balance(s) belonging to the user.
var UserVirtualCurrency#: object

# Dictionary of remaining times and timestamps for virtual cu
var UserVirtualCurrencyRechargeTimes#: VirtualCurrencyRechargeTime


func _get_type_for_property(property_name: String) -> String:
	match property_name:
		"AccountInfo":
			return "UserAccountInfo"
	
	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
