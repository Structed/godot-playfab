extends JsonSerializable
class_name EventContents

# The optional custom tags associated with the event (e.g. build number, external trace identifiers, etc.). Before an event is written, this collection and the base request custom tags will be merged, but not overriden. This enables the caller to specify static tags and per event tags.
var CustomTags: Dictionary

# Entity associated with the event. If null, the event will apply to the calling entity.
# **You should not set the Entity** unless you need to.
var Entity: EntityKey

# The namespace in which the event is defined. Allowed namespaces can vary by API.
var EventNamespace: String

# The name of this event.
var Name: String

# The original unique identifier associated with this event before it was posted to PlayFab. The value might differ from the EventId value, which is assigned when the event is received by the server.
var OriginalId: String

# The time (in UTC) associated with this event when it occurred. If specified, this value is stored in the OriginalTimestamp property of the PlayStream event.
var OriginalTimestamp: String

# Arbitrary data associated with the event. `PayloadJSON` is not implemented.
# If you ***need*** to use `PayloadJSON`, please use a verbaitim request instead.
var Payload: Dictionary


func _get_type_for_property(property_name: String) -> String:
	match property_name:
		"Entity":
			return "EntityKey"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

