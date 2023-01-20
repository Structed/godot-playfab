extends JsonSerializable
class_name EntityTokenResponse

## The entity id and type.
var Entity: EntityKey

## The token used to set X-EntityToken for all entity based API calls.
var EntityToken: String

## The time the token will expire, if it is an expiring token, in UTC.
var TokenExpiration: String

func _get_type_for_property(property_name: String) -> String:
	match property_name:
		"Entity":
			return "EntityKey"
	
	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
