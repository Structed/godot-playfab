extends JsonSerializable
class_name WriteEventsRequest

# Collection of events to write to PlayStream.
var Events: EventContentsCollection

# The optional custom tags associated with the request (e.g. build number, external trace identifiers, etc.).
var CustomTags: Dictionary


func _init():
	Events = EventContentsCollection.new()


func _get_type_for_property(property_name: String) -> String:
	match property_name:
		"Events":
			return "EventContentsCollection"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

