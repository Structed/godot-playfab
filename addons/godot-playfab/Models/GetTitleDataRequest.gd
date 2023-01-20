extends JsonSerializable
class_name GetTitleDataRequest

## This API is designed to return title specific values which can be read, but not written to, by the client.
## For example, a developer could choose to store values which modify the user experience,
## such as enemy spawn rates, weapon strengths, movement speeds, etc. This allows a developer
## to update the title without the need to create, test, and ship a new build. If the player
## belongs to an experiment variant that uses title data overrides, the overrides are applied
## automatically and returned with the title data. Note that there may up to a minute delay
## in between updating title data and this API call returning the newest value.

# Specific keys to search for in the title data (leave null to get all keys)
var Keys: Array = []

# Optional field that specifies the name of an override. This value is ignored when used by the game client; otherwise, the overrides are applied automatically to the title data.
var OverrideLabel: String = ""


func _get_type_for_property(property_name: String) -> String:
	match property_name:
		_:
			pass
	
	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
